#include <stdio.h>
#include <stdlib.h>
#include <termios.h>

// Very simple yes or no. Ignores everything else. Don't need to press enter, no wasted lines in your bash script getting and then checking a variable, no loops, no BS. 
// if yesno; then doit;else;dont;done

int c;
char r;
int main ()
{
	struct termios oldT, newT;
	char c;
//	ioctl(0,TCGETS,&oldT); 
	tcgetattr(0, &oldT);
	newT=oldT;
	newT.c_lflag &= ~ICANON;
//	ioctl(0,TCSETS,&newT);
	tcsetattr(0,TCSANOW,&newT);
	while(c=getc(stdin)) {
		r = c;
		if ((r == 'Y') || (r == 'y') || (r == 'N') || (r == 'n')) break;
		}
	tcsetattr(0,TCSANOW,&oldT);
//	ioctl(0,TCSETS,&oldT);
	if ((r == 'Y') || (r == 'y')) exit(0);
	exit (1);
}
