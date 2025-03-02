# sss

This is just a collection of tools I wrote to make my life easier. 
Not super advanced, but together, they can be quite useful.


# Structure
These utilitis are laid out in a Filesystem Hierarchy Standard (FHS) like manner, as I keep them in my home directory and add them to my path.

# Programs

- tmpfile
  - Outputs a unique file name in your $TMP directory
  - If you pass it a name as an argumnet, it will 
    - make that directory in $TMP if it doesn't exist
    - include that directory in the path it outputs
    - return an error if the name exists as a file

