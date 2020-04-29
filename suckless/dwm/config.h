/* See LICENSE file for copyright and license details. */

/* Enable multimedia keys */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showtitle          = 0;        /* 0 means no title */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Sans:size=11" };
static const char dmenufont[]       = "Sans:size=12";
static const char dmenuln[]         = "20";
/* Default colors
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
*/
/* Nord colors */
static const char col_gray1[]       = "#2e3440"; /* nord0 */
static const char col_gray3[]       = "#eceff4"; /* nord6 */
static const char col_gray4[]       = "#e5e9f0"; /* nord5 */
static const char col_cyan[]        = "#5e81ac"; /* nord10 */
static const char col_gray2[]       = "#81a1c1"; /* nord9 */
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "", "", "", "", "", "", "⏯", "", "🌍" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class         instance          title               tags mask     isfloating   monitor */
	{ "Gimp",           NULL,          NULL,               0,            1,           -1 },
	{ "MEGAsync",       NULL,          NULL,               1,            1,           -1 },
	{ "de-unistuttgart-ims-coref-annotator-Annotator", NULL, NULL, 1<<2, 1,           -1 },
	{ "Geany",          NULL,          NULL,               1<<2,         0,           -1 },
	{ "RStudio",        NULL,          NULL,               1<<2,         0,           -1 },
	{ "Eclipse",        NULL,          NULL,               1<<2,         0,           -1 },
	{ NULL,             NULL,          "top",              1<<4,         0,           -1 },
	{ "Skype",          NULL,          NULL,               1<<5,         0,           -1 },
	{ NULL,             "mpv-youtube", NULL,               1<<6,         0,           -1 },
	{ NULL,             NULL,          "mpv-youtube.bash", 1<<6,         0,           -1 },
	{ NULL,             NULL,          "youtube-viewer",   1<<6,         0,           -1 },
	{ NULL,             NULL,          "mpsyt",            1<<6,         0,           -1 },
	{ "Thunderbird",    NULL,          NULL,               1<<7,         0,           -1 },
	{ NULL,             NULL,          "mutt",             1<<7,         0,           -1 },
	{ "Firefox",        NULL,          NULL,               1<<8,         0,           -1 },
        { "Nightly",        NULL,          NULL,               1<<8,         0,           -1 },
	{ "qutebrowser",    NULL,          NULL,               1<<8,         0,           -1 },
	{ NULL,             "surf",        NULL,               1<<8,         0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "><>",      NULL },    /* no layout function means floating behavior */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-c", "-p", "Run:", "-l", dmenuln, "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "120x34", "-e", "/bin/sh", NULL };
static const char *statusbarcmd[] = { "statusbar", NULL }; /* Define command for starting dmenu-based statusbar */
static const char *lockcmd[] = { "slock", NULL }; /* Define command for locking screen */
static const char *volumeupcmd[] = { "pactl", "set-sink-volume", "0", "+1%", NULL };
static const char *volumedowncmd[] = { "pactl", "set-sink-volume", "0", "-1%", NULL };
static const char *volumemutecmd[] = { "amixer", "-q", "-D", "pulse", "sset", "Master", "toggle", NULL };
static const char *audiotogglecmd[] = { "mpc", "toggle", NULL };
static const char *brightnessupcmd[] = { "xbacklight", "-inc", "10", NULL };
static const char *brightnessdowncmd[] = { "xbacklight", "-dec", "10", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },
	{ MODKEY,             		XK_Return, spawn,          {.v = termcmd } },
	{ Mod1Mask,                     XK_s,      togglescratch,  {.v = scratchpadcmd } },
	{ MODKEY,                       XK_x,      togglebar,      {0} },
	{ MODKEY,			XK_b,	   spawn,	   {.v = statusbarcmd } },
	{ 0,                            XF86XK_AudioRaiseVolume, spawn, {.v = volumeupcmd } },
	{ 0,                            XF86XK_AudioLowerVolume, spawn, {.v = volumedowncmd } },
	{ 0,                            XF86XK_AudioMute, spawn, {.v = volumemutecmd } },
	{ 0,                            XF86XK_AudioPlay, spawn, {.v = audiotogglecmd } },
	{ 0,                            XF86XK_MonBrightnessUp, spawn, {.v = brightnessupcmd } },
	{ 0,                            XF86XK_MonBrightnessDown, spawn, {.v = brightnessdowncmd } },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_Left,   focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
        { MODKEY,                       XK_Right,  focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_s,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_g,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_z,      zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ Mod1Mask,                     XK_l,      spawn,          {.v = lockcmd } }, /* Define shortcut for lockcmd */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_e,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

