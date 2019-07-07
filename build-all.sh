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
    trap "tail -n 200 $logfile; rm $logfile;" EXIT
    $* 2>&1 | tee $logfile | \
       awk "{printf(\".\");fflush();} NR % 40 == 0 {printf(\"\n\");fflush()} END {printf(\"\n\")}"; \
    exit ${PIPESTATUS[0]}
    )
}

while read package ; do 
    if [[ $package == '#'* ]]; then
        continue
    fi
    conda build $* $pkgroot/$package || {
        echo "----- Failed -----"
        exit 1
    }
done < $pkglist
