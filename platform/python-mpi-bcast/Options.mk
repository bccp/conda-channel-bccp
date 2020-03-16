# on BlueWaters (cray)
# MPICC='cc -static'

# on COMA (CMU)
# MPICC=mpiicc LDSHARED="mpiicc -shared"

# on Fedora 19 with openmpi
# MPICC=mpicc LDSHARED="mpicc -shared"

# on Edison (gcc)
# MPICC='cc -static'

# static build
MPICC=mpicc -static -pthread

# install location; use $PREFIX from conda
# PREFIX=${PREFIX}

# force same CC as MPICC not needed likely
# CC=$(MPICC)

