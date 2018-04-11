#!/bin/bash

# workaround mpich/openmpi not built with the new toolchain

#if [[ $OSTYPE != darwin* ]]; then
#    # for MAC use system compilers
#    # because cross complilation doesn't work
#    export OMPI_CC=$CC
#    export MPICH_CC=$CC
#    export OMPI_CXX=$CXX
#    export MPICH_CXX=$CXX
#    export OMPI_FC=$FC
#    export MPICH_FC=$FC
#    export OMPI_CPPFLAGS="$CPPFLAGS -I$CONDA_PREFIX/include"
#    export OMPI_LDFLAGS="$LDFLAGS -L$CONDA_PREFIX/lib"
#    export OMPI_LIBS=$LIBS
#    export OMPI_CFLAGS="$CFLAGS -I$CONDA_PREFIX/include"
#    export OMPI_CXXFLAGS=$CXXFLAGS
#    export OMPI_FCFLAGS=$FCFLAGS
#else
#    export CFLAGS="-headerpad_max_install_names"
#    export CXXFLAGS=$CFLAGS
#fi

#echo --------------------
#which mpicc
#env
#echo -------------------


$PYTHON setup.py install
