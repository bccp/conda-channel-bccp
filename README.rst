
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

* `bigfile`_: A reproducible massively parallel IO library for hierarchical data

* `classylss`_: A Python binding of CLASS for large-scale structure calculations 
.. image:: https://zenodo.org/badge/61589760.svg
   :target: https://zenodo.org/badge/latestdoi/61589760
   
* `kdcount`_: A KDTree pair counter
.. image:: https://zenodo.org/badge/34348490.svg
   :target: https://zenodo.org/badge/latestdoi/34348490
* `mpsort`_: A Python binding of MP-sort, a peta scale sorting routine
* `nbodykit`_: Analysis kit for large-scale structure datasets, the massively parallel way
.. image:: https://zenodo.org/badge/34348490.svg
   :target: https://zenodo.org/badge/latestdoi/34348490
* `pfft-python`_: A Python binding of PFFT, a massively parallel FFT library
* `pmesh`_: Particle Mesh in Python
.. image:: https://zenodo.org/badge/28099917.svg
   :target: https://zenodo.org/badge/latestdoi/28099917
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
