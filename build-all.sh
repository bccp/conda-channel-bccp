err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

while read package ; do 
    echo Running ---- conda build $* $package;
    logfile=`mktemp XXXXX`
    conda build $* $package 2>&1 | tee $logfile | awk "{printf(\".\")} NR % 40 == 0 {print} END {print}"
    echo Result ----- $err
    tail $logfile
    rm -rf $logfile
done < build-order;

exit $err
