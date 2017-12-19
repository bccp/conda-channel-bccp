#!/bin/bash

if [ r"$PY3K" == r"1" ]; then
    export PYTHON_CONFIG_EXE=python3-config
else
    export PYTHON_CONFIG_EXE=python-config
fi

sed -e "s;@CC@;$CC;" \
    -e "s;@CFLAGS@;$CFLAGS;" \
    -e "s;@CLINK@;$LDFLAGS;" \
    -e "s;@PYTHON@;$PYTHON;" \
    -e "s;@PYTHON_CONFIG_EXE@;$CPYTHON_CONFIG_EXE;" \
    $RECIPE_DIR/common.mk.in > common.mk

make install

python setup.py install --single-version-externally-managed --record rec.txt

if [[ $OSTYPE != darwin* ]]; then
    cp $RECIPE_DIR/../../check-glibc.sh .
    bash check-glibc.sh $SP_DIR/Corrfunc || exit 1
fi
