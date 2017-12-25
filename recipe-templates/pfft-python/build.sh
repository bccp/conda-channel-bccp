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
#    export LIBS="-Wl,-rpath,$CONDA_PREFIX/lib"
#    export LDFLAGS="-headerpad_max_install_names"
#    export CXXFLAGS=$CFLAGS
#fi

if [[ $OSTYPE == darwin* ]]; then
    # this may need to be done on linux too,
    # see https://github.com/ContinuumIO/anaconda-issues/issues/739
    export LDFLAGS="$LDFLAGS -Wl,-rpath,${CONDA_PREFIX}/lib"
fi

# don't know if this is useful.
export FCFLAGS="$FFLAGS"

python setup.py install

