
.. image:: https://travis-ci.org/bccp/conda-channel-bccp.svg?branch=master
    :alt: Build Status
    :target: https://travis-ci.org/bccp/conda-channel-bccp
    
BCCP-related conda packages
============================

Here, we maintain a list of python packages, mostly cosmology related affialiated with or used by the `Berkeley
Center for Cosmological Physics`_ (BCCP). To install the conda packages maintained 
in this repository do:

.. code:: sh

    conda install -c bccp package_name
    
    
The packages maintained here are: 

* `abopt`_: ABstract OPTimizer: optimization of generic numerical models |abopt_doi|
* `bigfile`_: A reproducible massively parallel IO library for hierarchical data |bigfile_doi|
* `cachey`_: Caching based on computation time and storage space
* `classylss`_: A Python binding of CLASS for large-scale structure calculations |classylss_doi|
* `Corrfunc`_: Blazing fast correlation functions on the CPU |Corrfunc_doi|
* `fastpm-python`_: quasi N-body simulations using the FastPM scheme in Python |fastpm-python_doi|
* `fitsio`_: A python package for FITS input/output wrapping cfitsio
* `halotools`_: Python package for studying large scale structure, cosmology, and galaxy evolution using N-body simulations and halo models |halotools_doi|
* `kdcount`_: A KDTree pair counter |kdcount_doi|
* `mpsort`_: A Python binding of MP-sort, a peta scale sorting routine
* `mcfit`_: multiplicatively convolutional fast integral transforms in Python
* `nbodykit`_: Analysis kit for large-scale structure datasets, the massively parallel way |nbodykit_doi|
* `pfft-python`_: A Python binding of PFFT, a massively parallel FFT library |pfft-python_doi|
* `pmesh`_: Particle Mesh in Python |pmesh_doi|
* `runtests`_: Testing pytest based Python projects with optional support to variable MPI sizes. |runtests_doi|

.. _`Berkeley Center for Cosmological Physics` : http://bccp.berkeley.edu
.. _`bigfile` : https://github.com/rainwoodman/bigfile
.. _`classylss` : https://github.com/nickhand/classylss
.. _`kdcount` : https://github.com/rainwoodman/kdcount
.. _`mpi4py_test` : https://github.com/rainwoodman/mpi4py_test
.. _`mpsort` : https://github.com/rainwoodman/MP-sort
.. _`nbodykit`: https://github.com/bccp/nbodykit
.. _`pfft-python` : https://github.com/rainwoodman/pfft-python
.. _`pmesh`: https://github.com/rainwoodman/pmesh
.. _`runtests`: https://github.com/bccp/runtests
.. _`abopt`: https://github.com/bccp/abopt
.. _`cachey`: https://github.com/dask/cachey
.. _`Corrfunc`: https://github.com/manodeep/Corrfunc
.. _`fastpm-python`: https://github.com/rainwoodman/fastpm-python
.. _`fitsio`: https://github.com/esheldon/fitsio
.. _`halotools`: https://github.com/astropy/halotools
.. _`mcfit`: https://github.com/eelregit/mcfit

.. |abopt_doi| image:: https://zenodo.org/badge/74931755.svg
   :target: https://zenodo.org/badge/latestdoi/74931755
   
.. |bigfile_doi| image:: https://zenodo.org/badge/21016779.svg
   :target: https://zenodo.org/badge/latestdoi/21016779

.. |classylss_doi| image:: https://zenodo.org/badge/61589760.svg
   :target: https://zenodo.org/badge/latestdoi/61589760

.. |Corrfunc_doi| image:: https://zenodo.org/badge/DOI/10.5281/zenodo.594351.svg
   :target: https://doi.org/10.5281/zenodo.594351

.. |halotools_doi| image:: https://zenodo.org/badge/DOI/10.5281/zenodo.835895.svg
   :target: https://doi.org/10.5281/zenodo.835894

.. |kdcount_doi| image:: https://zenodo.org/badge/34348490.svg
   :target: https://zenodo.org/badge/latestdoi/34348490

.. |nbodykit_doi| image:: https://zenodo.org/badge/34348490.svg
   :target: https://zenodo.org/badge/latestdoi/34348490

.. |pmesh_doi| image:: https://zenodo.org/badge/28099917.svg
   :target: https://zenodo.org/badge/latestdoi/28099917
   
.. |runtests_doi| image:: https://zenodo.org/badge/64977808.svg
   :target: https://zenodo.org/badge/latestdoi/64977808
   
.. |pfft-python_doi| image:: https://zenodo.org/badge/26140163.svg
   :target: https://zenodo.org/badge/latestdoi/26140163
   
.. |fastpm-python_doi| image:: https://zenodo.org/badge/81290989.svg
   :target: https://zenodo.org/badge/latestdoi/81290989

The Anaconda channel of BCCP can be found at: http://anaconda.org/bccp/

General Plan
============

We use the cross-compilation toolchain introduced in anaconda 5.0 to build
the packages on Linux and OSX. 


platform directory
++++++++++++++++++
The current version of openmpi and mpich
on default anaconda channels are not properly set up to use the cross
compilation toolchain for the compiler wrappers. We therefore
build openmpi, mpich and a mpi4py that depends on them. The plan is to add
updated openmpi, mpich and mpi4py to the default anaconda channel eventually,
and stop including these packages.


build-order
+++++++++++

all packages must be listed in build-order in order to build them.
This is our poor man's version to resolve dependency. We loop
over the packages to get around

https://github.com/conda/conda-build/issues/2503


requirements.yaml
+++++++++++++++++

All packages also must be listed in requirements.yaml; except those
hard coded in platform directory. A python script, `extrude_recipes.py`
will find the latest version on pypi, generate a correctly versioned
recipe for the package in recipes directory.


variants/ directory
+++++++++++++++++++
We use a travis-ci matrix to determine the version of Python for conda-build.
This helps us to shrink the time to build the packages to within the travis time-limit.

OSX gfortran weirdness
++++++++++++++++++++++

We sometimes need to add LDFLAGS to make the gfortran compiler on OSX happy.

https://github.com/ContinuumIO/anaconda-issues/issues/739#issuecomment-238101203

Currrently this still applies to the cross-compilation toolchain. Hopefully this
will be fixed soon.



