# sss

This is just a collection of tools I wrote to make my life easier. 
Not super advanced, but together, they can be quite useful.


# Structure
These utilitis are laid out in a Filesystem Hierarchy Standard (FHS) like manner, as I keep them in my home directory and add them to my path.

For my use cases, I keep a tmpfs mounted on $HOME/usr/tmp, some of my design choices make more sense when you know that.

# Programs

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

