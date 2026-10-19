spt - simple pomodoro timer
===========================
spt is a simple timer that uses the pomodoro technique that doubles your
efficiency.

Features
--------
- Get the jobs done quicker than ever
- Keeps you free like a dog
- Able to show remaining time
- Optional work soundtrack, silent during breaks
- Work-time tracking through the standalone timetrack tool

Installation
------------
Edit config.mk to match your local setup (spt is installed into the /usr/local
namespace by default).

Afterwards enter the following command to build and install spt (if necessary
as root):

    make clean install

See the man pages for additional details.

Configuration
-------------
The configuration of spt is done by creating a custom config.h and
(re)compiling the source code. By default, the timer runs by 4
pomodoro timer (25 mins) with subsequent rests in between (5 mins)
followed by a long rest (15 mins) in an infinite loop.
Each timer entry has a duration in seconds, a work flag (1 for work, 0 for
break), and a notification message. The flag determines whether music plays;
the order of entries and their messages can be changed freely.

Work soundtrack
---------------
Use `-a` to play an audio file during work intervals (requires `mplayer`):

    spt -a "$CONCENTRATION_SOUNDTRACK" -e '' -n notify-send

The file loops until the work interval ends, then stops before the break.
Each work interval starts the file again from the beginning. No `-endpos`
setting is needed. SIGUSR2 pauses/resumes both the timer and the player;
SIGUSR1 shows the remaining time without starting another player. Exiting
with Ctrl-C, SIGTERM, or SIGHUP also stops the player.

The generic `-e` command keeps its existing behavior: it runs for every
notification, including work starts, break starts, and SIGUSR1 status
requests. The example uses `-e ''` to disable the default foghorn command in
config.h. Omit it to keep that alarm, or supply another command, for example:

    spt -a "$CONCENTRATION_SOUNDTRACK" -e 'aplay -q alarm.wav' -n notify-send

The `-a` value is a filename, not a shell command; quote paths containing
spaces. A default soundtrack can also be set with `audiofile` in config.h.

Time tracking
-------------
spt uses a separately installed `timetrack` executable, found through PATH.
It calls the existing `morning`, `break`, `resume` and `closing` commands;
the tracker must allow `closing` during a break. Install the tracker
separately; it is not built or installed with spt.

With `timetrack` available in PATH, tracking is enabled by default:

    spt -a "$CONCENTRATION_SOUNDTRACK" -e '' -n notify-send

If the executable has another name or lives elsewhere, use `-t`:

    spt -t "$HOME/.local/bin/timetrack.py" -a "$CONCENTRATION_SOUNDTRACK" -e ''

The `-t` value is an executable name or path, not a shell command. It need not
be in the spt directory. Change `trackcmd` in config.h to set another default,
or use `-t ''` to disable tracking.

One spt run uses one tracker session, starting with its first work period:

- The first work period starts: `timetrack morning`.
- A break or manual pause starts: `timetrack break`.
- Work resumes after a break or pause: `timetrack resume`.
- spt exits after tracking has started: `timetrack closing`.

Resuming a scheduled break and SIGUSR1 status requests do not change
tracking. Starting or exiting spt during an initial break creates no session
until work starts.

On exit during work, a break or a manual pause, spt calls `closing` once.
Closing during a break records departure without restarting work: work time
already stopped at the `break` entry. The tracker must support this sequence.

A small helper process inside spt runs these commands and closes the session
if the main timer disappears, including after SIGKILL. No tracker process
stays running between commands. The spt helper must survive to perform that
cleanup. A failed tracker command stops spt with an error.

Statistics remain available directly through the standalone tracker. Its
monthly, yearly and all-time reports are independent of this integration.
Start with a closed tracker session, and avoid changing the same session
manually or running another timer while spt controls it.

Links
-----
http://pomodorotechnique.com/


The project is licensed under the MIT license.
