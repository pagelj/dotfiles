/* See LICENSE file for copyright and license details. */
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/socket.h>
#include <sys/wait.h>
#ifdef NOTIFY
#include <libnotify/notify.h>
#endif /* NOTIFY */

#include "arg.h"

char *argv0;

/* macros */
#define LEN(a)  (sizeof(a) / sizeof(a[0]))


typedef struct {
	unsigned int tmr;
	int work;
	char *cmt;
} Timers;

#include "config.h"

static sigset_t mask;

/* function declarations */
static void die(const char *errstr, ...);
static pid_t spawn(char *argv[], int quiet);
static int track(char *action);
static int watch_tracker(int fd, pid_t parent);
static pid_t start_tracker(int *fd);
static int track_state(int fd, int work);
static void notify_send(char *cmt);
static void display_state(int remaining, int suspend);
static void usage(void);

/* functions implementations */
void
die(const char *errstr, ...)
{
	va_list ap;

	va_start(ap, errstr);
	vfprintf(stderr, errstr, ap);
	va_end(ap);
	exit(1);
}

pid_t
spawn(char *argv[], int quiet)
{
	pid_t pid;
	int fd;

	if ((pid = fork()) == 0) {
		setsid();
		sigprocmask(SIG_UNBLOCK, &mask, NULL);
		signal(SIGPIPE, SIG_DFL);
		if (quiet) {
			if ((fd = open("/dev/null", O_WRONLY)) == -1
			    || dup2(fd, STDOUT_FILENO) == -1
			    || dup2(fd, STDERR_FILENO) == -1)
				_exit(1);
			if (fd != STDOUT_FILENO && fd != STDERR_FILENO)
				close(fd);
		}
		execvp(argv[0], argv);
		perror(argv[0]);
		_exit(1);
	}
	if (pid < 0)
		perror("spt: fork");
	return pid;
}

int
track(char *action)
{
	pid_t pid, waited;
	int status;

	if ((pid = spawn((char *[]) { trackcmd, action, NULL }, 0)) > 0) {
		while ((waited = waitpid(pid, &status, 0)) == -1 && errno == EINTR)
			;
		if (waited == pid && WIFEXITED(status) && !WEXITSTATUS(status))
			return 1;
	}
	fprintf(stderr, "spt: %s %s failed\n", trackcmd, action);
	return 0;
}

int
watch_tracker(int fd, pid_t parent)
{
	struct pollfd pfd = { fd, POLLIN, 0 };
	int ready, work, started = 0, active = 0, failed = 0;
	char state;

	while (getppid() == parent) {
		if ((ready = poll(&pfd, 1, 1000)) < 0) {
			if (errno == EINTR)
				continue;
			failed = 1;
			break;
		}
		if (!ready)
			continue;
		if (read(fd, &state, 1) != 1 || getppid() != parent)
			break;
		work = state == 'W';
		if (work != active) {
			if (!track(work ? (started ? "resume" : "morning") : "break")) {
				failed = 1;
				break;
			}
			active = work;
			started = 1;
		}
		if (write(fd, "1", 1) != 1)
			break;
	}
	if (started && !track("closing"))
		failed = 1;
	return failed;
}

pid_t
start_tracker(int *fd)
{
	int sockets[2], i;
	pid_t pid, parent = getpid();

	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sockets) == -1)
		die("spt: cannot create tracker connection: %s\n", strerror(errno));
	for (i = 0; i < 2; i++)
		if (fcntl(sockets[i], F_SETFD, FD_CLOEXEC) == -1)
			die("spt: cannot protect tracker connection: %s\n", strerror(errno));
	if ((pid = fork()) == 0) {
		close(sockets[0]);
		setsid();
		/* Keep control signals blocked; the helper exits when spt does. */
		_exit(watch_tracker(sockets[1], parent));
	}
	close(sockets[1]);
	if (pid == -1)
		die("spt: cannot start tracker: %s\n", strerror(errno));
	*fd = sockets[0];
	return pid;
}

int
track_state(int fd, int work)
{
	char state = work ? 'W' : 'B', ack;
	struct pollfd pfd = { fd, POLLIN, 0 };

	if (fd < 0)
		return 1;
	if (write(fd, &state, 1) == 1 && poll(&pfd, 1, 10000) > 0
	    && read(fd, &ack, 1) == 1 && ack == '1')
		return 1;
	fputs("spt: time tracker failed; stopping timer\n", stderr);
	return 0;
}

void
notify_send(char *cmt)
{
	if (strcmp(notifycmd, ""))
		spawn((char *[]) { notifycmd, "spt", cmt, NULL }, 0);
#ifdef NOTIFY
	else {
		notify_init("spt");
		NotifyNotification *n = notify_notification_new("spt", cmt, \
					"dialog-information");
		notify_notification_show(n, NULL);
		g_object_unref(G_OBJECT(n));
		notify_uninit();
	}
#endif /* NOTIFY */

	if (strcmp(notifyext, "")) /* extra commands to use */
		spawn((char *[]) { "/bin/sh", "-c", notifyext, NULL }, 0);
}

void
display_state(int remaining, int suspend)
{
	char buf[29];

	snprintf(buf, 29, "Remaining: %02d:%02d %s",
		 remaining / 60,
		 remaining % 60,
		 (suspend) ? "◼" : "▶");

	notify_send(buf);
}

void
usage(void)
{
	die("usage: %s [-a audiofile] [-e notifyext] [-n notifycmd] [-t tracker] [-v]\n", argv0);
}

int
main(int argc, char *argv[])
{
	struct timespec remaining, before, after;
	pid_t player, waited, tracker = 0;
	long long ns;
	int i, sig, status, trackfd = -1, suspend = 0, done = 0;

	ARGBEGIN {
		case 'a':
			audiofile = EARGF(usage());
			break;
		case 'e':
			notifyext = EARGF(usage());
			break;
		case 'n':
			notifycmd = EARGF(usage());
			break;
		case 't':
			trackcmd = EARGF(usage());
			break;
		case 'v':
			die("spt " VERSION " © 2015-2020 spt engineers, "
			    "see LICENSE for details\n");
		default:
			usage();
	} ARGEND;

	/* Wait for signals in the timer loop, without a check/sleep race. */
	sigemptyset(&mask);
	sigaddset(&mask, SIGUSR1);
	sigaddset(&mask, SIGUSR2);
	sigaddset(&mask, SIGINT);
	sigaddset(&mask, SIGTERM);
	sigaddset(&mask, SIGHUP);
	if (sigprocmask(SIG_BLOCK, &mask, NULL) == -1)
		die("cannot block timer signals\n");
	signal(SIGPIPE, SIG_IGN);
	if (*trackcmd)
		tracker = start_tracker(&trackfd);

	for (i = 0; !done; i = (i + 1) % LEN(timers)) {
		if (!track_state(trackfd, timers[i].work && !suspend)) {
			done = -1;
			break;
		}
		printf("%s\n", timers[i].cmt);
		notify_send(timers[i].cmt);
		player = 0;
		if (timers[i].work && *audiofile) {
			player = spawn((char *[]) { "mplayer", "-really-quiet",
				"-noconsolecontrols", "-loop", "0", "--", audiofile, NULL }, 1);
			if (player > 0 && suspend)
				kill(player, SIGSTOP);
		}
		remaining.tv_sec = timers[i].tmr;
		remaining.tv_nsec = 0;
		while ((remaining.tv_sec || remaining.tv_nsec) && !done) {
			if (!suspend)
				clock_gettime(CLOCK_MONOTONIC, &before);
			sig = suspend ? sigwaitinfo(&mask, NULL)
			              : sigtimedwait(&mask, NULL, &remaining);
			if (!suspend) {
				clock_gettime(CLOCK_MONOTONIC, &after);
				ns = remaining.tv_sec * 1000000000LL + remaining.tv_nsec;
				ns -= (after.tv_sec - before.tv_sec) * 1000000000LL
				      + after.tv_nsec - before.tv_nsec;
				if (ns < 0)
					ns = 0;
				remaining.tv_sec = ns / 1000000000LL;
				remaining.tv_nsec = ns % 1000000000LL;
			}
			switch (sig) {
			case SIGUSR1:
				display_state(remaining.tv_sec, suspend);
				break;
			case SIGUSR2:
				suspend ^= 1;
				if (player > 0)
					kill(player, suspend ? SIGSTOP : SIGCONT);
				if (!track_state(trackfd, timers[i].work && !suspend))
					done = -1;
				break;
			case SIGINT:
			case SIGTERM:
			case SIGHUP:
				done = sig;
				break;
			}
		}
		if (player > 0) {
			kill(player, SIGTERM);
			kill(player, SIGCONT); /* A paused player must run to exit. */
			while (waitpid(player, NULL, 0) == -1 && errno == EINTR)
				;
		}
	}

	if (trackfd >= 0) {
		close(trackfd); /* The spt helper closes the session on EOF or parent death. */
		while ((waited = waitpid(tracker, &status, 0)) == -1 && errno == EINTR)
			;
		if (waited == -1 || !WIFEXITED(status) || WEXITSTATUS(status))
			done = -1;
	}
	return done < 0 ? 1 : 128 + done;
}
