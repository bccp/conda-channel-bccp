#! /bin/bash

if [ "x$2" == x ]; then
    echo  "Usage: bash build-all.sh packagelistdir packagelistfile [conda-build args ...]"
    exit 1
fi

pkgroot=$1
pkglist=$2
shift
shift

err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

while read package ; do 
    if [[ $package == '#'* ]]; then
        echo bypassing comment $package
        continue
    fi
    echo Running ---- conda build $* $pkgroot/$package;
    logfile=`mktemp XXXXX`
    conda build $* $pkgroot/$package 2>&1 | tee $logfile | awk "{printf(\".\")} NR % 40 == 0 {printf(\"\n\")} END {printf(\"\n\")}"
    echo Result ----- $err
    tail $logfile
    rm -f $logfile
done < $pkglist

exit $err
