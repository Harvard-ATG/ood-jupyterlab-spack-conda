# Batch Connect - Jupyter Lab Server

This repository contains an implementation of an Open OnDemand app that serves a Jupyter Lab environment using spack to manage software dependencies. It is built to run in the AWS Parallel Cluster environment managed by Harvard University IT Academic Technology.

The repository is based on the [example Jupyter app](https://github.com/OSC/bc_example_jupyter) provided by OSC.

## Prerequisites

This Batch Connect app requires the following software be installed in a location accessible to the compute nodes that will run the tasks:

- [Spack](https://spack.io/)
  - A Spack environment containing `py-jupyterlab` and any other spack packages containing Python modules that are desired.
  - The `spack.yaml` file from an environment configured for this app is included in this repo at `spack-environment/jupyter/spack.yml`.

The default location for spack and the default environment name are defined in `form.yml`.

## Optional Additions

The app is set up to allow the use of different spack install locations and different environment names. That means that if a user has set up their own spack installation, or if a different configuration has been created for their use, that user can change their launch configuration from the app form and use different Python libraries in the same interface.

## Install

This repository should be added to the OnDemand app configuration. By default, this can be found at /var/www/ood/apps/sys.

## Environment install script

The spack install process can take a long time, which is problematic when trying to maintain a terminal session. To assist, this repo includes a script to use with `sbatch` to install dependencies as a slurm job. The script is set up for use with the default global spack installation, but can be modified to activate whatever environment is desired.

With this script, the install process looks like this:
- Create a jupyter environment
- Add packages to the environment definition
- Run the `installSpackEnvironment.sh` script as an sbatch script to install the dependencies asynchronously
- Check on the progress of the job by tailing the log file or just seeing if the job is still running with `squeue`
- When the job finishes, verify that packages are present with `spack find` and check for errors in the log output files.
