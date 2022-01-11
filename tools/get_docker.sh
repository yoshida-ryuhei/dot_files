#!/bin/bash

if [[ $# != 1 ]] ; then
	echo -e "input must be \n ./get_docker.sh (all|active)"
	exit
fi

input=$(echo $1 | awk '{print tolower($0)}' )
if [[ $input == "all" ]] ; then 
	command="docker ps -a"
elif [[ $input == "active" ]] ; then 
	command="docker ps "
else 
	echo "input is invalid"
	exit
fi

if [[ answer=${command} ]];then 
	echo ${answer} | echo $((`wc -l`-1 )) 
else
	echo "null"
fi
