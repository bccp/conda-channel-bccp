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

_DIRNAME=`dirname ${_SCRIPT_LOCATION}`/..
_DIRNAME=`readlink -f $_DIRNAME`

# execute from the script's directory
pushd $_DIRNAME

INSTALL_FLAG=""
BUILD_FLAG="--skip-existing"

# get the CLEAN flags
if [ "$1" = "--clean" ]; then
    INSTALL_FLAG="-f"
    BUILD_FLAG=""
    shift
fi

ENVNAME=$PYTHON

# get the bundle-anaconda command
source /usr/common/contrib/bccp/python-mpi-bcast/activate.sh

# activate our root anaconda install to start
source /usr/common/contrib/bccp/anaconda3/bin/activate root

# purge intermediate results
conda build purge

# keep conda and conda-build up to date
conda update --yes conda conda-build

# directory where recipes will be written
RECIPE_DIR=recipes-$ENVNAME

# make the recipes
rm -rf $RECIPE_DIR
mkdir -p $RECIPE_DIR
python extrude_recipes.py requirements.yml --recipe-dir $RECIPE_DIR || { echo "extrude_recipes failed"; exit 1; }

build ()
{
    local PYTHON=$1
    local BUILD_ARGS="-m variants/${NERSC_HOST}/python-${PYTHON}.yaml $BUILD_FLAG --no-test -c astropy"
    bash build-all.sh platform pkglist-nersc-platform $BUILD_ARGS
    bash build-all.sh $RECIPE_DIR pkglist $BUILD_ARGS
}

install ()
{
    local PYTHON=$1
    # dirty way to get a list of recipe names
    pushd recipe-templates

    # install packages into this python version's environment
    source activate $ENVNAME
    conda uninstall --yes mpich2
    conda install $INSTALL_FLAG --use-local --yes * ||
    { echo "conda install of packages failed"; exit 1; }
    conda update --yes --use-local -f * || { echo "forced conda update failed"; exit 1; }
    conda update --yes --use-local --all || { echo "conda update all failed"; exit 1; }
    popd

    # and tar the install
    bundle-anaconda /usr/common/contrib/bccp/anaconda3/envs/bccp-anaconda-$PYTHON.tar.gz $CONDA_PREFIX ||
    { echo "bundle-anaconda failed"; exit 1; }
}

# build packages for specific python version
build $PYTHON

# install
install $ENVNAME

popd # return to start directory
