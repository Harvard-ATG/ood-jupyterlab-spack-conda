#!/bin/bash
# Install packages in a conda environment given in the first argument

# Activate spack
. /shared/spack/share/spack/setup-env.sh

# Activate conda environment
spack env activate cs109a

# Create conda environment and install python packages
conda env create --file conda-environment/cs109a/environment.yml
