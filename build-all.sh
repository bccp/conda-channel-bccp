err=0
#trap 'err=1' ERR;
trap 'exit 1' ERR;

VARIANT=$1
shift

pushd platform

conda build $* mpich3
conda build $* openmpi3
conda build $* mpi4py

popd

pushd recipes;

while read package ; do 
    echo Running ---- conda build -m ../$VARIANT $INSPECT $UPLOAD $package-*;
    conda build -m ../$VARIANT $* $INSPECT $UPLOAD $package-*;
    echo Result ----- $err
done < ../build-order;

popd

exit $err
