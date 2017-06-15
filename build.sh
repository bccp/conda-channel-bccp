#!/bin/bash

# only one argument allowed
if [ $# -eq 1 ] && [ "$1" != "--clean" ]; then
    echo "usage: build.sh [--clean]"
    exit 1
fi

INSTALL_FLAG=""
BUILD_FLAG="--skip-existing"

# get the CLEAN flags
if [ "$1" = "--clean" ]; then
    INSTALL_FLAG="-f"
    BUILD_FLAG=""
    shift
fi

# cd to the conda-channel-bccp dir
cd /usr/common/contrib/bccp/conda-channel-bccp

# get the latest changes from github
# git reset --hard
# git checkout nersc
# git pull origin nersc

# get the bundle-anaconda command
source /usr/common/contrib/bccp/python-mpi-bcast/activate.sh

# activate our root anaconda install to start
source /usr/common/contrib/bccp/anaconda3/bin/activate root
conda build purge

# make the recipes
python extrude_recipes requirements.yml

build_mpi4py ()
{
    local PYTHON=$1
    pushd recipes
    conda build --python $PYTHON mpi4py-cray
    popd
}

build ()
{
    local PYTHON=$1
    local NUMPY=$2

    pushd recipes
    for f in *; do
        if [ $f != "mpi4py-cray" ]; then
            conda build --python $PYTHON --numpy $2 $BUILD_FLAG $f
        fi
    done
    popd
}

install ()
{
    local PYTHON=$1
    pushd recipe-templates

    # install packages into this python version's environment
    source activate $PYTHON
    conda install $INSTALL_FLAG --use-local --yes *
    conda update --yes --use-local *
    conda update --yes --use-local --all
    popd

    # and tar the install
    bundle-anaconda /usr/common/contrib/bccp/anaconda3/envs/bccp-anaconda-$PYTHON.tar.gz $CONDA_PREFIX

}

# build fresh mpi4py first
build_mpi4py 2.7
build_mpi4py 3.6
build_mpi4py 3.5

# build packages for each python, numpy version pair
build 2.7 1.11
build 3.6 1.11
build 3.5 1.11
build 2.7 1.12
build 3.6 1.12
build 3.5 1.12
build 2.7 1.13
build 3.6 1.13
build 3.5 1.13

# install
install 2.7
install 3.6
install 3.5

# set the permissions
setfacl -R -m m::rwx \
           -m u:yfeng1:rwX \
           -m u:nhand:rwX \
    /usr/common/contrib/bccp/anaconda3 \
    /usr/common/contrib/bccp/conda-channel-bccp
