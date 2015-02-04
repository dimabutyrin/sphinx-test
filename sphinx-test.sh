#!/bin/bash

readarray array < ./sphinx-queries.txt
host=$1
type=$2
if [ -z "$1" ]
then
   host="127.0.0.1"
fi

function run-parallel {
for i in "${array[*]}"
	do
	echo "$i" | mysql -h $host -P 9306 > /dev/null &
	done
}

function run-by-one {
for i in "${array[@]}"
        do
        echo "$i" | mysql -h $host -P 9306 > /dev/null;
        done
}

function count-time {
T="$(($(date +%s%N)-T))";
S="$((T/1000000000))";
# Milliseconds
M="$((T/1000000))";
echo "Time in milliseconds: ${M}";
}

echo $host;

case $type in
	by-one)
	T="$(date +%s%N)";
	run-by-one;
	count-time;
	;;
	all)
	T="$(date +%s%N)";
	run-parallel;
	count-time;
	;;
	*) #wrong type, show help
	echo "$(basename "$0") [ARG] -- script for sphinx testing
	USAGE:
	$(basename "$0") - for localhost testing
	$(basename "$0") hostIPorFQDN - for non-localhost testing"
esac
