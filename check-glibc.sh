#! /bin/bash

set -e
if ! [ -d $1 ]; then
    echo Folder $1 does not exist -- did you give a wrong destination or forget --single-version-externally-managed
    exit 1
fi

fns=`find $1 -name '*.so'`
for fn in $fns; do
    echo "--- GLIBC symbols in $fn --"
    objdump -T $fn | grep GLIBC | awk '
        BEGIN { bad = 0 }
        {print $0}
        /GLIBC_2\.1[3-9]/ {
            bad = 1
        }
        /GLIBC_2\.[2-9][0-9]/ {
            bad = 1
        }
        END {
            if (bad) print("Bad symbols detected");
            exit bad;
        }
    '
done
