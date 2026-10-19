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

Links
-----
http://pomodorotechnique.com/


The project is licensed under the MIT license.
