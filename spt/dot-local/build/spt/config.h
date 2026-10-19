/* See LICENSE file for copyright and license details. */

/* Notification, remove DNOTIFY in config.mk if you don't want it */
static char *notifycmd = "notify-send"; /* Uses given command if not compiled by DNOTIFY */
static char *notifyext = "aplay -q ~/.local/foghorn.wav"; /* Notify with extra command (eg. play an alarm) */
static char *audiofile = ""; /* Work soundtrack; overridden by -a */
static char *trackcmd = "timetrack"; /* Tracker executable; -t overrides, empty disables */

/*
 * This is the array which defines all the timer that will be used.
 * It will be repeated after all of it is executed.
 */
static Timers timers[] = {
    /* timer(s)  work (1 = work, 0 = break)  comment */
    {     1500,  1, "💻 (1/4) Time to start working! (25 min)"},
    {      300,  0, "🫖 Time to start resting! (5 min)"},
    {     1500,  1, "💻 (2/4) Time to start working! (25 min)"},
    {      300,  0, "🫖 Time to start resting! (5 min)"},
    {     1500,  1, "💻 (3/4) Time to start working! (25 min)"},
    {      300,  0, "🫖 Time to start resting! (5 min)"},
    {     1500,  1, "💻 (4/4) Time to start working! (25 min)"},
    {      900,  0, "😴 Time to take some nap! (15 min)"},
};
