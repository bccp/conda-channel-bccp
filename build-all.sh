VARIANT=$1

pushd recipes;

err=0
trap 'err=1' ERR;
while read package ; do 
    echo Running ---- conda build -m ../$VARIANT $INSPECT $UPLOAD $package-*;
    conda build -m ../$VARIANT $INSPECT $UPLOAD $package-*;
    echo Result ----- $err
done < ../build-order;

popd

exit $err
