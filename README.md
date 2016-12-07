Manifold-valued Multivariate General Linear Models (MMGLMs) with Matlab scripts for generating small jobs for HTConder
====

NEWS!!!

c++ code for DTI based on Armadillo takes 1 min 43 sec per voxel!
40-50 times faster than unoptimized Matlab code.
10 times faster than optimized Matlab code.

Dependent libraries
---
* matlabtools (common)
* FreeSurferMatlab (not included)
* my_mrtrix-0.2.11/matlab (for ODFs, not included)
* Cramertest (cramer's test)


Note
------
You might need to have these libraries installed to compile c++ MMGLMs module for 3x3 SPDs.
As in Ubuntu here's the commands:
```
sudo apt-get install -y  liblapack-dev liblapacke liblapacke-dev libblas-dev gfortran
libatlas-base-dev liblapack3 libarmadillo-dev libarmadillo6 libarmadillo6-dbgsym
libboost-dev libboost-system-dev libboost-filesystem-dev
```
