#!/bin/bash

# only one argument allowed
if [ $# -eq 0 ] || [ $# -gt 2 ] || [ $# -eq 2 ] && [ "$2" != "--clean" ]; then
    echo "usage: build.sh PYTHON [--clean]"
    exit 1
fi

if [[ -n $BASH_VERSION ]]; then
    _SCRIPT_LOCATION=${BASH_SOURCE[0]}
elif [[ -n $ZSH_VERSION ]]; then
    _SCRIPT_LOCATION=${funcstack[1]}
else
    echo "Only bash and zsh are supported"
    exit 1
fi

# the PYTHON version to build
PYTHON=$1
shift

# start build from the parent of nersc directory, where these scripts are.

_DIRNAME=`dirname ${_SCRIPT_LOCATION}`
_PARENTDIR=`readlink -f ${_DIRNAME}/..`
_DIRNAME=`readlink -f ${_DIRNAME}`

# execute from the script's parent directory
pushd $_PARENTDIR

git pull

INSTALL_FLAG=""
BUILD_FLAG="--skip-existing"

# get the CLEAN flags
if [ "$1" = "--clean" ]; then
    INSTALL_FLAG="-f"
    BUILD_FLAG=""
    shift
fi

MPI=${NERSC_HOST}.prgenv.gnu.mpi 

# activate our root anaconda install to start
source /usr/common/contrib/bccp/anaconda3/bin/activate root

# purge intermediate results
conda build purge

# keep conda and conda-build up to date
conda update --yes conda conda-build

build ()
{
    local PYTHON=$1
    # directory where recipes will be written
    RECIPE_DIR=recipes-$PYTHON
    
    # make the recipes
    rm -rf $RECIPE_DIR
    mkdir -p $RECIPE_DIR
    python extrude_recipes.py requirements.yml --recipe-dir $RECIPE_DIR || { echo "extrude_recipes failed"; exit 1; }

    local BUILD_ARGS="-m variants/${NERSC_HOST}/python-${PYTHON}.yaml $BUILD_FLAG --no-test -c astropy"
    bash build-all.sh platform pkglist-nersc-platform $BUILD_ARGS
    bash build-all.sh $RECIPE_DIR pkglist $BUILD_ARGS
}

install ()
{
    # undocumented feature 
    # https://github.com/conda/conda/pull/6413
    # since we will bcast the bundle to /dev/shm/local
    # set it here.
    
    export CONDA_TARGET_PREFIX_OVERRIDE=/dev/shm/local
    local PYTHON=$1
    local ENVNAME=bcast-anaconda-$1

    conda env remove -y -n $ENVNAME
    conda create -y -n $ENVNAME
    conda install -y -n $ENVNAME $INSTALL_FLAG --use-local \
	python=$PYTHON \
	${MPI} \
	--file nersc/environment.txt
}

bundle ()
{
    local ENVNAME=bcast-anaconda-$1

    # enable python-mpi-bcast
    source $CONDA_PREFIX/envs/$ENVNAME/libexec/python-mpi-bcast/activate.sh    

    # and tar the install
    bundle-anaconda /usr/common/contrib/bccp/anaconda3/envs/$ENVNAME.tar.gz $CONDA_PREFIX/envs/$ENVNAME ||
    { echo "bundle-anaconda failed"; exit 1; }
}

install_script()
{
    local ENVNAME=bcast-anaconda-$1
    source $CONDA_PREFIX/envs/$ENVNAME/libexec/python-mpi-bcast/activate.sh    
    cp $_DIRNAME/activate-bcast $CONDA_PREFIX/envs/$ENVNAME/bin
}

# build packages for specific python version
build $PYTHON

# install
install $PYTHON

# install
bundle $PYTHON

install_script $PYTHON
popd # return to start directory
