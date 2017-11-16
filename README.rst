
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
* `fastpm-python`_: quasi N-body simulations using the FastPM scheme in Python
* `fitsio`_: A python package for FITS input/output wrapping cfitsio
* `halotools`_: Python package for studying large scale structure, cosmology, and galaxy evolution using N-body simulations and halo models |halotools_doi|
* `kdcount`_: A KDTree pair counter |kdcount_doi|
* `mpsort`_: A Python binding of MP-sort, a peta scale sorting routine
* `mcfit`_: multiplicatively convolutional fast integral transforms in Python
* `nbodykit`_: Analysis kit for large-scale structure datasets, the massively parallel way |nbodykit_doi|
* `pfft-python`_: A Python binding of PFFT, a massively parallel FFT library
* `pmesh`_: Particle Mesh in Python |pmesh_doi|
* `runtests`_: Testing pytest based Python projects with optional support to variable MPI sizes.

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

The Anaconda channel of BCCP can be found at: http://anaconda.org/bccp/

GLIBC 2.12 compatibility
========================

The packages are built on a relatively recent system provided by Travis-CI for free. The GLIBC version
on the travis system is likely > 2.20. 

On linux-like platforms we use GCC voodoo to pin down the version of GLIBC API required by
the binary object to earlier than GLIBC 2.12, ensuring these binary packages can work on systems deployed
as early as 2010. (e.g. CentOS 6.x) The magic is in glibc-compat.h, which is prefixed to every C/C++ source
code file. 

Alternatively (the more mainstream way) one can build these binaries on systems with an earlier version of GLIBC by,
for example creating a docker image or a virtual machine that runs a CentOS 6.x userland.
The mainstream way is less fun than actually figuring out how the API version is contolled in an ELF file by `ld.so`.
That being said,
we shall explore the docker image / virtual machine approach in the future because it is much easier than
the GCC voodoo we use here, and has the potential to work for Fortran and other exotic programming languages.
