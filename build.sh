
git reset --hard
git checkout nersc
git pull origin nersc

source /usr/common/contrib/bccp/anaconda3/bin/activate root

python extrude_recipes requirements.yml

build ()
{
    local PYTHON=$1
    
    pushd recipes
    conda build --no-test mpi4py
    for f in *; do
        conda build --no-test --skip-existing --python $PYTHON $f
    done
    
    source activate $PYTHON
    conda install --use-local *
    
    popd
    
}

build 2.7
build 3.6