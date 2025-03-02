/* dnslookup.c
 * prints out all hostnames of a specified ip-address
 * or prints out all ip-addresses of a specified hostname
 * Modified by Fred Dinkler IV to print error to standard
 * output instead of error, making use in scripted output
 * easier.
 */

#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>

int main(int argc, char* argv[])
{
        struct hostent *host;
        struct in_addr addr;
        int i = 0;

        if (argc != 2)
        {
                printf("usage: %s <ip_addr | hostname>\n", argv[0]);
                return 1;
        }

        if (!inet_aton(argv[1], &addr))
        {
                host = gethostbyname(argv[1]);

                if (host)
                {
                        while(host->h_addr_list[i])
                                printf("%s -> %s\n", argv[1], inet_ntoa(*(struct in_addr*)host->h_addr_list[i++]));
			return(0);
                }
                else
                        printf("%s -> gethostbyname_failed\n", argv[1]);
			return(1);
        }
        else
        {
                host = gethostbyaddr((const char*)&addr, sizeof(addr), AF_INET);

                if (host)
                {
                        printf("%s -> %s\n", argv[1], host->h_name);
                        while(host->h_aliases[i])
                                printf("%s -> %s\n", argv[1], host->h_aliases[i++]);
			return(0);
                }
                else
                        printf("%s -> gethostbyaddr_failed\n", argv[1]);
			return(1);
        }

        return 0;
}

