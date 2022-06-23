//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/


	{"", "sh ~/.config/dwmblocks/scripts/date",					60,		0},
	{"", "sh ~/.config/dwmblocks/scripts/time",					1,		0},

	{"", "sh ~/.config/dwmblocks/scripts/separator",					360,		0},
    //left extra bar

	{"", "sh ~/.config/dwmblocks/scripts/separator",					360,		0},
    //right extra bar


	{"", "sh ~/.config/dwmblocks/scripts/mem",	15,		0},
	{"", "sh ~/.config/dwmblocks/scripts/cpu",	15,		0},
	{"", "sh ~/.config/dwmblocks/scripts/battery",	30,		0},

};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = "";
static unsigned int delimLen = 5;
