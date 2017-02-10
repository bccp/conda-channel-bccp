module load PrgEnv-gnu
export MPICC=cc
python setup.py install --single-version-externally-managed --record rec.txt
