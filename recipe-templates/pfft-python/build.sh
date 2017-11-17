#!/bin/bash

# workaround mpich/openmpi not built with the new toolchain

export OMPI_CPPFLAGS="$CPPFLAGS -I$CONDA_PREFIX/include"
export OMPI_LDFLAGS="$LDFLAGS -L$CONDA_PREFIX/lib"
export OMPI_LIBS=$LIBS
export OMPI_CC=$CC
export MPICH_CC=$CC
export OMPI_CFLAGS="$CFLAGS -I$CONDA_PREFIX/include"
export OMPI_CXX=$CXX
export MPICH_CXX=$CXX
export OMPI_CXXFLAGS=$CXXFLAGS
export OMPI_FC=$FC
export MPICH_FC=$FC
export OMPI_FCFLAGS=$FCFLAGS

export MPICC=mpicc

$PYTHON setup.py install 

if [[ $OSTYPE != darwin* ]]; then
    cp $RECIPE_DIR/../../check-glibc.sh .
    bash check-glibc.sh $SP_DIR/pfft || exit 1
fi
