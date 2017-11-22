#!/bin/bash

if [[ $OSTYPE == darwin* ]]; then
    # this may need to be done on linux too,
    # see https://github.com/ContinuumIO/anaconda-issues/issues/739
    export LDFLAGS="$LDFLAGS -Wl,-rpath,${CONDA_PREFIX}/lib"
fi

# don't know if this is useful.
export FCFLAGS="$FFLAGS"

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --enable-cxx \
            --enable-f77 \
            --enable-fc #\
#            --with-cross=$RECIPE_DIR/cross.conf

make -j$CPU_COUNT
make install

if [[ $OSTYPE != darwin* ]]; then
    cp $RECIPE_DIR/../check-glibc.sh .
    bash check-glibc.sh $PREFIX/lib/ || exit 1
fi
