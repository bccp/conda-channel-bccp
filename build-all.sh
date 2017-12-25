#! /bin/bash

if [ "x$1" == x ]; then
    echo  "Usage: bash build-all.sh packagelistfile [conda-build args ...]"
    exit 1
fi

pkglist=$1
shift

err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

while read package ; do 
    if [[ $package == '#'* ]]; then
        echo bypassing comment $package
        continue
    fi
    echo Running ---- conda build $* $package;
    logfile=`mktemp XXXXX`
    conda build $* $package 2>&1 | tee $logfile | awk "{printf(\".\")} NR % 40 == 0 {printf(\"\n\")} END {printf(\"\n\")}"
    echo Result ----- $err
    tail $logfile
    rm -f $logfile
done < $pkglist

exit $err
