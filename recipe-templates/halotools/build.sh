#!/bin/bash
if [[ $OSTYPE == darwin* ]]; then
     export CFLAGS="-headerpad_max_install_names"
     export CXXFLAGS=$CFLAGS
else
     export CFLAGS="-include $PWD/glibc-compat.h"
fi

cp $RECIPE_DIR/../../glibc-compat.h .
cp $RECIPE_DIR/../../check-glibc.sh .

$PYTHON setup.py install --offline

if [[ $OSTYPE != darwin* ]]; then
    bash check-glibc.sh $SP_DIR/$PKG_NAME || exit 1
fi
