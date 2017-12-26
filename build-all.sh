#! /bin/bash

if [ "x$2" == x ]; then
    echo  "Usage: bash build-all.sh packagelistdir packagelistfile [conda-build args ...]"
    exit 1
fi

pkgroot=$1
pkglist=$2
shift
shift

log2dots ()
{
    (
    echo ----- Running "$*"
    logfile=`mktemp XXXXX`
    trap "rm $logfile;" EXIT
    trap "err=1" ERR
    $* 2>&1 | tee $logfile | \
       awk "{printf(\".\")} NR % 40 == 0 {printf(\"\n\")} END {printf(\"\n\")}"; \
    tail $logfile
    exit $err
    )
}

while read package ; do 
    if [[ $package == '#'* ]]; then
        continue
    fi
    log2dots conda build $* $pkgroot/$package || {
        echo "----- Failed -----"
        exit 1
    }
done < $pkglist
