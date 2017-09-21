#!/bin/bash
if [[ $OSTYPE == darwin* ]]; then
     export CFLAGS="-headerpad_max_install_names"
     export CXXFLAGS=$CFLAGS
else
     export CFLAGS="-include $PWD/glibc-compat.h"
fi

$PYTHON setup.py install

if [[ $OSTYPE != darwin* ]]; then
    bash check-glibc.sh $SP_DIR/$PKG_NAME/*.so || exit 1
fi
