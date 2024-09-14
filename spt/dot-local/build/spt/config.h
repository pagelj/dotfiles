/* See LICENSE file for copyright and license details. */

/* Notification, remove DNOTIFY in config.mk if you don't want it */
static char *notifycmd = "notify-send"; /* Uses given command if not compiled by DNOTIFY */
static char *notifyext = "aplay -q ~/.local/foghorn.wav"; /* Notify with extra command (eg. play an alarm) */

/*
 * This is the array which defines all the timer that will be used.
 * It will be repeated after all of it is executed.
 */
static Timers timers[] = {
	/* timer(s)  comment */
	{     1500,  "💻 (1/4) Time to start working!"},
	{      300,  "🫖 Time to start resting!"},
	{     1500,  "💻 (2/4) Time to start working!"},
	{      300,  "🫖 Time to start resting!"},
	{     1500,  "💻 (3/4) Time to start working!"},
	{      300,  "🫖 Time to start resting!"},
	{     1500,  "💻 (4/4) Time to start working!"},
	{      900,  "😴 Time to take some nap!"},
};
