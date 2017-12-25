#!/bin/bash

for fn in \
    mpicc \
    mpicxx \
    mpifort \
    mpif77 \
    mpif90 \
    mpi.conf \
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

install mpi.conf $PREFIX/etc/
