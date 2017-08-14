USER=bccpuser

set +x
set +e
source /etc/profile.d/nerschost.sh
source /etc/profile.d/modules.sh
source /etc/profile.d/mpi-selector.sh
source /etc/bash.bashrc.local

module unload PrgEnv-intel
module load PrgEnv-gnu
module list
set -e
set -x
