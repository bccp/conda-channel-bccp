#!/bin/bash

if [ `uname` == Darwin ]; then
    export LIBS="-Wl,-rpath,$CONDA_PREFIX/lib"
    export CC=clang
else
    export CFLAGS="-include $PWD/glibc-compat.h"
fi

cp $RECIPE_DIR/../../glibc-compat.h .
cp $RECIPE_DIR/../../check-glibc.sh .

# add libm see https://github.com/esheldon/fitsio/pull/135
patch < $RECIPE_DIR/patch.libm

$PYTHON setup.py install
if [[ $OSTYPE != darwin* ]]; then
    bash check-glibc.sh $SP_DIR/$PKG_NAME || exit 1
fi
