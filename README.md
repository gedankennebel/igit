gitool
======

The little rebase tool for lazy people
--------------------------------------
 
This script will perform a rebase with the latest remote master branch, by following steps:
* checkout master
* pull changes from remote
* go automatically back to working branch
* perform rebase, if requested (with -i) also in interactive mode

Options:
* -r perform rebase for current branch
* -i perform rebase with interactive rebase mode
* -a rebase all branches
* -m rebase and merge current branch to master using squash

For convinience copy this script to your bin folder. Here is how to do for Mac OSX:
```
mv gitool.sh gitool
mv gitool /usr/local/bin
```

Then use it from anywhere like: gitool -r
