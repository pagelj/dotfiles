/* See LICENSE file for copyright and license details. */
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
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
static pid_t spawn(char *argv[]);
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
spawn(char *argv[])
{
	pid_t pid;

	if ((pid = fork()) == 0) {
		setsid();
		sigprocmask(SIG_UNBLOCK, &mask, NULL);
		execvp(argv[0], argv);
		perror(argv[0]);
		_exit(1);
	}
	if (pid < 0)
		perror("spt: fork");
	return pid;
}

void
notify_send(char *cmt)
{
	if (strcmp(notifycmd, ""))
		spawn((char *[]) { notifycmd, "spt", cmt, NULL });
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
		spawn((char *[]) { "/bin/sh", "-c", notifyext, NULL });
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
	die("usage: %s [-a audiofile] [-e notifyext] [-n notifycmd] [-v]\n", argv0);
}

int
main(int argc, char *argv[])
{
	struct timespec remaining, before, after;
	pid_t player;
	long long ns;
	int i, sig, suspend = 0, done = 0;

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

	for (i = 0; !done; i = (i + 1) % LEN(timers)) {
		printf("%s\n", timers[i].cmt);
		notify_send(timers[i].cmt);
		player = 0;
		if (timers[i].work && *audiofile) {
			player = spawn((char *[]) { "mplayer", "-really-quiet",
				"-noconsolecontrols", "-loop", "0", "--", audiofile, NULL });
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

	return 128 + done;
}
