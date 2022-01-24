/* dnslookup.c
 * prints out all hostnames of a specified ip-address
 * or prints out all ip-addresses of a specified hostname
 * Modified by Fred Dinkler IV to print error to standard
 * output instead of error, making use in scripted output
 * easier.
 */

#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <byteswap.h>
int main(int argc, char* argv[])
{
        struct in_addr addr1;
        struct in_addr addr2;
        struct in_addr addrc;
	unsigned int a;
	unsigned int b;
	unsigned int i;
	int n;
	char buffer[33];
	char ip[33];
        if (argc != 3)
        {
                fprintf(stderr, "usage: %s <Start IP> <End IP>\n", argv[0]);
                return 1;
        }

        if (!inet_aton(argv[1], &addr1))
        {
		fprintf(stderr, "%s dosent look like an IP.\n", argv[1]);
		return 1;
	}
	a = ntohl(addr1.s_addr);
	fprintf(stderr, "Start:%i\n", a);
        if (!inet_aton(argv[2], &addr2))
        {
		fprintf(stderr, "%s dosent look like an IP.\n", argv[2]);
		return 1;
	}
	b = ntohl(addr2.s_addr);
	fprintf(stderr, "Stop:%i\n\n", b);
	for ( i = a; i <= b; i++ ) {
		snprintf(ip, 25, "%i", i);
		if (!inet_aton(ip, &addrc)) {
			fprintf(stderr, "Iternal error");
			return 1;
		}
		char *dot_ip = inet_ntoa(addrc);
//		printf("%s %s\n",dot_ip, ip);
		printf("%s\n",dot_ip);
	}
        return 0;
}

