//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

	{"", "sh ~/.config/dwmblocks/scripts/nettraf download",   1,		0},
	{"", "sh ~/.config/dwmblocks/scripts/nettraf upload",     1,		0},

	/* {"", "sh ~/.config/dwmblocks/scripts/mem",                1,		0}, */
	/* {"", "sh ~/.config/dwmblocks/scripts/cpu",                1,		0}, */
	/* {"", "sh ~/.config/dwmblocks/scripts/battery",            60,		0}, */

	/* {"", "sh ~/.config/dwmblocks/scripts/volume",             0,		1}, */
	/* {"", "sh ~/.config/dwmblocks/scripts/brightness",		  0,		2}, */
	{"", "sh ~/.config/dwmblocks/scripts/date",               360,		0},
	{"", "sh ~/.config/dwmblocks/scripts/time",               60,		0},




};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = "";
static unsigned int delimLen = 5;
