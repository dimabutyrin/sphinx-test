#!/bin/bash

readarray array < ./sphinx-queries.txt
type=$1
if [ -z "$1" ]
then
   type="by-one"
fi
host=$2
if [ -z "$2" ]
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
echo "Total time in milliseconds: ${M}";
}

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
	*) #wrong arguments, show help
	echo "$(basename "$0") [TYPE HOST] -- script for sphinx testing
	USAGE:
	$(basename "$0") all - for localhost parallel queris testing
	$(basename "$0") by-one some.host.name - for ony-by-one testing on some.host.name"
esac
