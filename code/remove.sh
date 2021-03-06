#!/bin/bash
# -*- coding: utf-8 -*-
# Copyright (c) 2013, Frank Rosquin <frank@rosquin.net>
# ISC license
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# Last Modified François Dupont 2015-05-28
blade="100.127.255.1"
daysback=31
port=9200
start_from=4
target="firewall"

while getopts b:d:p:s:t: option
do
case $option in
    b)
        blade=$OPTARG
        ;;
    d)
        if [ $OPTARG -ge 0 ]; then
        daysback=$OPTARG
        else
            echo "-d should be a number, 0 or more"
            echo ""
            print_usage
        fi
        ;;
    p)
        if [ $OPTARG -ge 0 ]; then
        port=$OPTARG
        else
            echo "-p should be a number, 0 or more"
            echo ""
            print_usage
        fi
        ;;
    s)
        if [ $OPTARG -ge 0 ]; then
        start_from=$OPTARG
        else
            echo "-s should be a number, 0 or more"
            echo ""
            print_usage
        fi
        ;;
    t)
        target=$OPTARG
        ;;
    \?)
        print_usage
        ;;
esac
done

end=$(expr $start_from \+ $daysback)
if [ $? == 0 ]; then
for i in $(seq $start_from $end); do
    d=$(date --date "$i days ago" +"%Y.%m.%d")
    curl -sS -XDELETE $blade:$port/$target-$d 
done
else
    echo "Invalid number of days specified, aborting"
fi
curl -XPOST "$blade:$port/_optimize"

print_usage() {
    echo "
Usage   : $0 [OPTIONS]
Options :
    -b blade : name or ip of the elasticsearch server
        default : 100.127.255.1 
    -d daysback : number of days/indexes deleted (from start day)
        default : 31
    -p port number
        default : 9200
    -s start number, starting delete day (-s 4 = if we are the 30/04 it starts deleting from 26/04 included)
        default : 4
    -t target name of the indices
        default : firewall
Example :  
    
"
    exit 0
}
