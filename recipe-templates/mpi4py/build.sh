echo $HOME
touch $HOME/.dbgdot
USER=yfeng1

set +x
source /etc/profile.d/nerschost.sh
source /etc/profile.d/modules.sh
source /etc/profile.d/mpi-selector.sh
source /etc/bash.bashrc.local
set -x

module unload PrgEnv
module load PrgEnv-gnu
module list
export MPICC=cc
python setup.py install --single-version-externally-managed --record rec.txt
