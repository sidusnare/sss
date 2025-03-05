# sss

This is just a collection of tools I wrote to make my life easier. 
Not super advanced, but together, they can be quite useful.


# Structure
These utilitis are laid out in a Filesystem Hierarchy Standard (FHS) like manner, as I keep them in my home directory and add them to my path.

For my use cases, I keep a tmpfs mounted on $HOME/usr/tmp, some of my design choices make more sense when you know that.

# Programs
- yesno
  - takes no arguments
  - ignores all input except
    - Returns 0 for Y or y
    - Returns 1 for N or n
- hn
  - Takes 3 arguments
    - Host name
    - Port number
    - Timeout
  - If it can connect to the server on that port inside the timout, returns true
  - Otherwise returns false
- slower
  - It's like cat
    - but slower
      - on purpose
- ip.unrange
  - Given a start and end IP, prints all IPs between
- dnslookup
  - Fast
  - Simple
  - Looks up an IP if given a name
  - Looks up a name if given an IP
- myfactor
  - Simply factors a number
  - Handy for making clean `dd size= count=` calculations

# Scripts

- tmpfile
  - Outputs a unique file name in your $TMP directory
  - If you pass it a name as an argumnet, it will 
    - make that directory in $TMP if it doesn't exist
    - include that directory in the path it outputs
    - return an error if the name exists as a file
- check.*.py
  - Reads a file in the specified format
  - Return error if file cannot be read
- clean.*.py
  - Reads a file in the specified format
  - Writes that file back out in same format
  - Good for canonicalizing data
- isip.sh
  - takes one argument, a string
  - returns true if it is a valid IPv4 addess
- oom_check.sh
  - Checks if OOM is in `dmesg`
- strace.py
  - Cleans up strace output
  - Still needs improvements
- myip_r53.sh
  - Creates or updates an A record in AWS Route53 based on machine's current IP
- tvi
  - Uses tmpfile to create a file and edit it
  - Passes all args through to vi, so any vi options can be used
- tmpcat
  - Uses tmpfile to create a file and cat into it
  - Uses argv1 as tmpfile name, shifts, and passes rest to cat
- qg
  - Takes argv as a commit message
  - does a git-up if installed, git pull --rebase otherwise
  - does a commit of everything outstanding in repo
  - pushes that commit on all remote
  - if `-f` supplied, returns true if any remote takes the push
  - if `-y` supplied, doesn't ask for Y/N before comitting
- ssh.find
  - Looks for the ssh agent in the places where I keep it
- ssh.start
  - Starts an ssh agent in the place whree I keep it
- ressh
  - Starts an ssh agent if one isn't running
  - Adds keys from the usual place
- wait.*
    - Waits for server names provided on the specified protocol to start responding
- wait.no*
    - Waits for server names provided on the specified protocol to sopt responding and then start responding
- flatten
  - replaces control characters with escaped control characters for use with `echo -e`
- se
  - Saves enviroment to file
- le
  - Sources enviroment from file
- isip
  - Takes IP, returns true if argv[1] is a string that can be interpreted as an IP
- isipv6
  - Takes IP, returns true if argv[1] is a string that can be interpreted as an IPv6
- res
  - Returns the virtual window size of the current display in X11
    - If running uneven multiple displays, this will include dead spots
    - Will be the overall size, not any individual sizes unless there is only 1 display
- cres
  - returns the text resolution of a console
