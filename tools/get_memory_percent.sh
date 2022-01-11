#!/bin/bash

if [ $(uname) == "Linux" ] ; then
	free | awk 'NR==2 {print int($3.0*1000/$2.0)/10.0}' | awk '{printf"%2.1f%\n",$1}'
elif [ $(uname) == "Darwin" ] ; then
	ps -A -o %mem | awk '{ mem += $1} END {print mem"%"}'
else
	echo "unknown OS"
fi
