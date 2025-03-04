#include <iostream>
#include <cmath>
#include <string>
using namespace std;

int main(int argc, char** argv) {
    unsigned long long int n, i, l;
    switch(argc) {
    	case 0:
    	case 1:
		cout << "Please provide number to factor\n";
    		exit(1);
		break;
	case 2:
    		n = stoll(argv[1]);
		l = stoll(argv[1]);
		break;
	case 3:
    		n = stoll(argv[1]);
		l = stoll(argv[2]);
		break;
    }
    if( argc >= 4) {
    	cout << "Please provide number to factor and optionally a limit\n";
	exit(1);
    }
    for(i = 1; i <= n; ++i) {
        if(n % i == 0) {
            cout << i << "\n";
	    }
	if( i >= l ) {
		exit(0);
	}
    }

    return 0;
}
