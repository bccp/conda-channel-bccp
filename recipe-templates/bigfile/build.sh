#!/bin/bash
if [[ $OSTYPE == darwin* ]]; then
     export CFLAGS="-headerpad_max_install_names"
     export CXXFLAGS=$CFLAGS
else
     export CFLAGS="-include $PWD/glibc-compat.h"
fi

cp $RECIPE_DIR/glibc-compat.h .

$PYTHON setup.py install
