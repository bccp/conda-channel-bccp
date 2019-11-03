#!/bin/bash

# where are we running this?
hostname

if [[ -n $BASH_VERSION ]]; then
    _SCRIPT_LOCATION=${BASH_SOURCE[0]}
elif [[ -n $ZSH_VERSION ]]; then
    _SCRIPT_LOCATION=${funcstack[1]}
else
    echo "Only bash and zsh are supported"
    exit 1
fi

OPTS=`getopt -o c --long clean -- "$@"`
if [ $? != 0 ]; then
    echo "usage: build.sh PYTHON [command] [--clean]"
    exit 1
fi

INSTALL_FLAG=""
BUILD_FLAG="--skip-existing"
eval set -- "$OPTS"
while true; do
    case "$1" in 
    -c | --clean )
    # get the CLEAN flags
        INSTALL_FLAG="-f"
        BUILD_FLAG=""
    shift ;;
    -- )
    shift; break;;
    esac
done

# the PYTHON version to build
PYTHON=$1
COMMAND=$2

# start build from the parent of nersc directory, where these scripts are.

_DIRNAME=`dirname ${_SCRIPT_LOCATION}`
_PARENTDIR=`readlink -f ${_DIRNAME}/..`
_DIRNAME=`readlink -f ${_DIRNAME}`

# execute from the script's parent directory
pushd $_PARENTDIR

git pull

MPI=${NERSC_HOST}.prgenv.gnu.mpi 

# activate our root anaconda install to start
source /global/common/software/m3035/conda/bin/activate root

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
    local ENVNAME=bcast-bccp-$1

    conda env remove -y -n $ENVNAME
    conda create -y -n $ENVNAME
    conda install -y -n $ENVNAME $INSTALL_FLAG --use-local \
	python=$PYTHON \
	${MPI} \
	--file nersc/environment.txt || { echo "install packages faied"; exit 1; }
    conda clean --all --yes
}

sync () {
    CHANNEL_DEST=/project/projectdirs/m3035/www/channels/${NERSC_HOST}/bccp
    mkdir -p $CHANNEL_DEST
    rsync -avr $CONDA_PREFIX/conda-bld/linux-64 $CHANNEL_DEST
    rsync -avr $CONDA_PREFIX/conda-bld/noarch $CHANNEL_DEST
    conda index $CHANNEL_DEST
}

bundle ()
{
    local ENVNAME=bcast-bccp-$1

    # enable python-mpi-bcast
    source $CONDA_PREFIX/envs/$ENVNAME/libexec/python-mpi-bcast/activate.sh    

    # and tar the install
    local NEW=$CONDA_PREFIX/envs/$ENVNAME.tar.gz.new
    local OLD=$CONDA_PREFIX/envs/$ENVNAME.tar.gz.yesterday
    local DST=$CONDA_PREFIX/envs/$ENVNAME.tar.gz
    bundle-anaconda $NEW $CONDA_PREFIX/envs/$ENVNAME ||
    { echo "bundle-anaconda failed"; exit 1; }

    # rotate
    mv $DST $OLD
    mv $NEW $DST
}

install_script()
{
    local ENVNAME=bcast-bccp-$1
    source $CONDA_PREFIX/envs/$ENVNAME/libexec/python-mpi-bcast/activate.sh    
    cp $_DIRNAME/activate-bcast $CONDA_PREFIX/envs/$ENVNAME/bin
}

if [ -z "$COMMAND" ]; then
  # build packages for specific python version
  build $PYTHON
  # copy packages to https://portal.nersc.gov/project/m3035/channels/${NERSC_HOST}/bccp
  sync $PYTHON
  # install
  install $PYTHON
  # bundle
  bundle $PYTHON
  # install the activate scripts
  install_script $PYTHON
else
  $COMMAND $PYTHON 
fi

popd # return to start directory
