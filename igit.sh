#!/bin/bash

version=0.2.1

if [ "$1" == "-help" ]
then
 printf "\e[32m \nThe little rebase tool for lazy people\n"
 echo "--------------------------------------"
 printf "\e[0m \nThis script will perform a rebase with the latest remote master branch, by following steps:\n"
 printf "* checkout master\n"
 printf "* pull changes from remote\n"
 printf "* go automatically back to working branch\n"
 printf "* perform rebase, if requested (with -i) also in interactive mode\n"
 printf "\nOptions:\n"
 printf "* -r perform rebase for current branch\n"
 printf "* -i perform rebase with interactive rebase mode\n"
 printf "* -a rebase all branches\n"
 printf "* -m rebase and merge current branch to master using squash\n"
 printf "* -d delete current branch and go to master\n"
 printf "* -v print version\n"
 printf " \n"
 exit 1
fi

doRebase() {
if [ "$1" != "master" ]
 then
  printf "\e[32m\nStarting rebase ...\n\n\e[0m"
  current_branch="$1"
  git checkout master
  git pull
  git checkout $current_branch
  if [ "$2" == "-i" ]
   then 
    git rebase master -i
   else
    git rebase master
  fi
  if [ "$(git symbolic-ref HEAD --short)" == "$current_branch" ]
   then 
    printf "\e[32m\nRebase successful! :)\n\n\e[0m"
   else
    printf "\e[31m\nRebase not done yet, you may have to resolve conflicts :(\n\n\e[0m"
  fi  
 else
  printf "\e[31mYou are in master branch, no need to rebase master with master! :P\n\e[0m"
fi
}

# rebase all branches
if [ "$1" == "-a" ]
 then
  while true; do
   read -p "Are you sure you want to rebase all branches? y/n " yn
   case $yn in
       [Yy]* ) break;;
       [Nn]* ) exit;;
       * ) echo "Please answer yes or no.";;
   esac
  done
  starting_branch=$(git symbolic-ref HEAD --short)
  branches=()
  eval "$(git for-each-ref --shell --format='branches+=(%(refname))' refs/heads/)"
   for branch in "${branches[@]}"; do
    current_brancg=$( echo "$branch" | cut -c 12- )
    doRebase "$current_branch"
   done
  git checkout $starting_branch
fi

# rebase and merge branch to master using squash
if [ "$1" == "-m" ]
 then
  printf "\e[32m\nStarting merge...\n\e[0m"
  current_branch=$(git symbolic-ref HEAD --short)
  doRebase "$current_branch"
  git checkout master
  printf "\e[32m\nNow performing merge to master with squash\n\e[0m"
  git merge $current_branch --squash
  printf "\e[32m\nMerge done!\nYour are in the master branch, now commit your awesome stuff and may edit the squased commit texts.. \n\e[0m"
fi

# rebase with interactive mode
if [ "$1" == "-i" ]
 then
  current_branch=$(git symbolic-ref HEAD --short)
  doRebase "$current_branch" "$1"
fi

# rebase current branch
if [ "$1" == "-r" ]
 then
  current_branch=$(git symbolic-ref HEAD --short)
  doRebase "$current_branch"
fi

# delete current branch and go to master
if [ "$1" == "-d" ]
 then
 current_branch=$(git symbolic-ref HEAD --short)
 git checkout master
 git branch -D "$current_branch"
 printf "\e[32m\n%s has been deleted.. RIP!\n\n\e[0m" $current_branch
fi

# print version
if [ "$1" == "-v" ]
 then
 printf "igit version %s\n" $version 
fi

# no parameter: show usage
if [[ -z "$1" ]]
 then
  printf "\nUsage:\n\n"
  echo "-r perform rebase for current branch"
  echo "-i perform rebase with interactive rebase mode"
  echo "-a rebase all branches"
  echo "-m rebase and merge current branch to master using squash"
  echo "-d delete current branch and go to master" 
  echo "-v print version\n" 
  printf " \n"
  exit 1
fi
