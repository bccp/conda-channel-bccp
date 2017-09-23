#!/bin/bash

if [ `uname` == Darwin ]; then
	export LIBS="-Wl,-rpath,$CONDA_PREFIX/lib"
    export CXXFLAGS=$CFLAGS
else
    export CFLAGS="-include $PWD/glibc-compat.h"
    export LIBS="-lm" # because the compat fails fftw3's -lm check
fi

cp $RECIPE_DIR/../../glibc-compat.h .
cp $RECIPE_DIR/../../check-glibc.sh .

$PYTHON setup.py install 

if [[ $OSTYPE != darwin* ]]; then
    bash check-glibc.sh $SP_DIR/pfft || exit 1
fi
