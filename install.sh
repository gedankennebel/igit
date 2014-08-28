#!/bin/bash

mv igit.sh igit
cp igit /usr/local/bin
chmod +x /usr/local/bin/igit
mv igit igit.sh
printf "\e[32m\nigit has been installed in /usr/local/bin. \e[31m<3\n\e[0m"
printf "\nInstalled version: "
igit -v
printf "\n"
