#include <stdio.h>
#include <time.h>
#include <stdlib.h>

//From Landon Bland on stackexchange.com at Wed Jan 23 10:37:04 EST 2019 URI https://unix.stackexchange.com/questions/290179/how-to-slow-down-the-scrolling-of-multipage-standard-output-on-terminal 


int main(int argc, char** argv) {
    int delay;
    char* rem;
    if (argc > 1) {
        delay = strtol(argv[1], &rem, 10);
    } else {
        delay = 500;
    }

    char* line;
    size_t bufsize = 0;

    struct timespec ts;
    ts.tv_sec = delay / 1000;
    ts.tv_nsec = (delay % 1000) * 1000000;

    while (getline(&line, &bufsize, stdin) != -1) {
        printf("%s", line);
        nanosleep(&ts, NULL);
    }
    free(line);
}

