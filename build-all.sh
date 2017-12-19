err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

while read package ; do 
    echo Running ---- conda build $* $package;
    buildlog=`mktemp XXXXXX`
    conda build $* $package 2>&1 > $buildlog
    echo Result ----- $err
    tail $buildlog
done < build-order;

exit $err
