source /usr/common/contrib/bccp/conda-channel-bccp/nersc_profile.sh
export MPICC=cc
python setup.py install --single-version-externally-managed --record rec.txt
