set +e
export USER=bccpuser
source /etc/profile.d/nerschost.sh
source /etc/profile.d/modules.sh
source /etc/profile.d/mpi-selector.sh
source /etc/bash.bashrc.local

module unload PrgEnv-intel
module load PrgEnv-gnu

module list

export CC=cc
export CXX=CC
export FC=ftn
export F77=ftn
