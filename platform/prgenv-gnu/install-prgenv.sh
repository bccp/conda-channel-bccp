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

mkdir -p ${PREFIX}/bin

for fn in \
    mpicc \
    mpicxx \
    mpifort \
    mpif77 \
    mpif90 \
    ; do
    install $fn ${PREFIX}/bin/
done

mkdir -p ${PREFIX}/etc
mkdir -p ${STDLIB_DIR}
install mpi.conf ${PREFIX}/etc/
install _sysconfigdata_x86_64_conda_nersc_prgenv_gnu.py ${STDLIB_DIR}

# Copy cray specific pkgconfig files such that if pkg-config is installed,
# we link to the correct cray packages.
mkdir -p ${PREFIX}/lib/pkgconfig
cp /usr/lib64/pkgconfig/*cray*.pc ${PREFIX}/lib/pkgconfig
