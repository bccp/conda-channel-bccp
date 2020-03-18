set +e
if [ "x$USER" == "x" ]; then
	# need to set a fake user name for modules.sh
	export USER=condabuild
fi
source /etc/profile.d/nerschost.sh
source /etc/profile.d/modules.sh
source /etc/profile.d/mpi-selector.sh
source /etc/bash.bashrc.local

module unload PrgEnv-intel
module load PrgEnv-gnu
# As of Jul 30th 2019, hugepages crashes mpi4py
module unload craype-hugepages2M
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
export NUMEXPR_MAX_THREADS=2

# see https://github.com/ContinuumIO/anaconda-issues/issues/9621
# do not use SYSCONFIG:
# it sounded like a good idea
# but it requires installing prgenv.gnu in the host section
# which makes no sense.

#export _OLD_CONDA_PYTHON_SYSCONFIGDATA_NAME=${_CONDA_PYTHON_SYSCONFIGDATA_NAME}
#export _CONDA_PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata_x86_64_conda_nersc_prgenv_gnu

# Therefore, we prefer overriding LDSHARED with the environment variable
# causing linking failures
# therefore, we set LDSHARED explicitly here
export LDSHARED="cc -pthread -shared"

export MPICH_MAX_THREAD_SAFETY=multiple

# recommended by Stephen Bailey for better multiprocessing support.
export KMP_AFFINITY=disabled
export MPICH_GNI_FORK_MODE=FULLCOPY

# remove any PYTHONPATH left-overs from Cray
export -n PYTHONPATH
# and PYTHONSTARTUP reads the history from HOME, which can be slow.
export -n PYTHONSTARTUP

# Hack to avoid astropy accessing the home directory.
# This will ignore the astropy configurations in the home dir.
export XDG_CACHE_HOME=/tmp/cache
export XDG_CONFIG_HOME=/tmp/config
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_CONFIG_HOME

mkdir -p $XDG_CACHE_HOME/astropy
mkdir -p $XDG_CONFIG_HOME/astropy

