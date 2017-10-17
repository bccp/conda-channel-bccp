DESTINATION_CONDA_CHANNEL="bccp"
TARGET_ARCH="x64"
CONDA_INSTALL_LOCN="${HOME}/miniconda"

# Defines BINSTAR_TOKEN for your binstar channel

# The python build restriction MUST be set at the moment, though it
# can have any value. The setting below avoids known-bad builds on
# python 2.6 and 3.3 for some packages.
PYTHON_BUILD_RESTRICTIONS="2.7*|>3.4"

NUMPY_BUILD_RESTRICTION="numpy >=1.11*"
# The value below needs to be set but will be ignored.
CONDA_NPY="1.11"
CONDA_VERSION=4.2*

# Matrix is fully specified (for now) by os versions

# Install and set up miniconda.
conda config --set always_yes true

# pin conda verson to 4.3.22
conda config --set auto_update_conda False
echo "conda ==4.3.22" >> ${CONDA_INSTALL_LOCN}/conda-meta/pinned

conda install --quiet conda

# set the ordering of additional channels
conda config --prepend channels defaults
conda config --append channels bccp
conda config --append channels astropy
conda config --append channels conda-forge # for conda-build-all (will be moved to defaults soon)

# Install a couple of dependencies we need for sure.
conda install --quiet --yes astropy anaconda-client=1.6.2 jinja2 cython pycrypto
conda install ruamel_yaml

# latest conda build
conda install 'conda-build<3'

# Install conda-build-all
conda install -c conda-forge conda-build-all

# To ease debugging, list installed packages
conda info -a

# Only upload if this is NOT a pull request.
INSPECT="--inspect-channels bccp"
UPLOAD="";
if [ x"$CIRCLE_PULL_REQUEST" == "x" ]; then
      echo "Uploading enabled";
      UPLOAD="--upload-channels $DESTINATION_CONDA_CHANNEL";
fi
# Get ready to build.
python extrude_recipes requirements.yml
# Packages are uploaded as they are built.
if [[ -d recipes ]]; then conda build-all recipes --matrix-max-n-minor-versions 3 --matrix-conditions "python $PYTHON_BUILD_RESTRICTIONS" "$NUMPY_BUILD_RESTRICTION"  $INSPECT $UPLOAD; fi
