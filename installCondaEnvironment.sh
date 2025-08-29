#!/bin/bash
# Install packages in a conda environment given in the first argument

# Activate spack
. /shared/spack/share/spack/setup-env.sh

# Activate conda environment
spack env activate conda

# Added these lines because previous attempts were failing and this was the recommendation
# in the slurm output logs.
echo "--- Automatically accepting Conda Terms of Service for default channels ---"
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
echo "--- Conda ToS accepted. Proceeding with environment creation. ---"

# Create conda environment and install python packages
conda env create --file conda-environment/$1/environment.yml
