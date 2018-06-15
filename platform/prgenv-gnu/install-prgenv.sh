#!/bin/bash

for fn in \
    mpicc \
    mpicxx \
    mpifort \
    mpif77 \
    mpif90 \
    mpi.conf \
    _sysconfigdata_x86_64_conda_nersc_prgenv_gnu.py \
    \
    ; do
    sed -e \
       "s;@PREFIX@;$PREFIX;g"  \
       $RECIPE_DIR/${fn}.in >$fn
    chmod +x $fn
done

for fn in \
    mpicc \
    mpicxx \
    mpifort \
    mpif77 \
    mpif90 \
    ; do
    install $fn $PREFIX/bin/
done

mkdir -p ${STDLIB_DIR}
install mpi.conf $PREFIX/etc/
install _sysconfigdata_x86_64_conda_nersc_prgenv_gnu.py ${STDLIB_DIR}
