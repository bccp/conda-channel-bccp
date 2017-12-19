err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

while read package ; do 
    echo Running ---- conda build $* $package;
    conda build $* $package 2>&1
    echo Result ----- $err
done < build-order;

exit $err
