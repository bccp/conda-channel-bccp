set +e
source /etc/profile.d/nerschost.sh
source /etc/profile.d/modules.sh
source /etc/profile.d/mpi-selector.sh
source /etc/bash.bashrc.local

module unload PrgEnv-intel
module load PrgEnv-gnu
# because the glibc on nersc is buggy
module swap gcc gcc/5.3.0
module list

export CFLAGS="-fPIC"
export CRAYPE_LINK_TYPE=dynamic
export CC=cc
export CXX=CC
export FC=ftn
export F77=ftn
# set a reasonable number for number of threads,
# to avoid 'pthreads_create: Resource temporarily unavailable' error.
export OMP_NUM_THREADS=2

export _OLD_CONDA_PYTHON_SYSCONFIGDATA_NAME=${_CONDA_PYTHON_SYSCONFIGDATA_NAME}
export _CONDA_PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata_x86_64_conda_nersc_prgenv_gnu
