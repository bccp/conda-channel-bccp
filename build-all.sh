err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

while read package ; do 
    echo Running ---- conda build $* $package;
    conda build $* $package 2>&1 > build-log-$package
    echo Result ----- $err
    tail build-log-$package
done < build-order;

exit $err
