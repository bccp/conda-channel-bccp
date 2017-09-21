#! /bin/bash

objdump -T $1 | grep GLIBC | awk '
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
