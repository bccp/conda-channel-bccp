#!/bin/bash
set -e

command -v mpicc
#mpicc -show

command -v mpicxx
#mpicxx -show

command -v mpifort
#mpifort -show

command -v mpif90
#mpif90 -show

command -v mpif77
#mpif77 -show

pushd $RECIPE_DIR/tests

mpicc helloworld.c -o helloworld_c

mpicxx helloworld.cxx -o helloworld_cxx

mpif90 helloworld.f90 -o helloworld_f90

mpif77 helloworld.f -o helloworld_f

popd
