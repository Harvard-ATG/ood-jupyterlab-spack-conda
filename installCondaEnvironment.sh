#!/bin/bash
# Install packages in a conda environment given in the first argument

# Activate spack
. /shared/spack/share/spack/setup-env.sh

# Activate conda environment
spack env activate conda

# Create conda environment and install python packages
conda env create --file conda-environment/$1/environment.yml
