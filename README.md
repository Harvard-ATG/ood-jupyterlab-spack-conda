# Batch Connect - Jupyter Lab Server

This repository contains an implementation of an Open OnDemand app that serves a Jupyter Lab environment using spack to manage software dependencies. It is built to run in the AWS Parallel Cluster environment managed by Harvard University IT Academic Technology.

The repository is based on the [example Jupyter app](https://github.com/OSC/bc_example_jupyter) provided by OSC.

## Prerequisites

This Batch Connect app requires the following software be installed in a location accessible to the compute nodes that will run the tasks:

- [Spack](https://spack.io/)
  - A Spack environment containing `miniconda3` (or equivalent) and any other spack packages that are required.
  - The `spack.yaml` file from an environment configured for this app is included in this repo at `spack-environment/conda/spack.yml`.
- [Conda](https://docs.anaconda.com/miniconda/)
  - A conda environment containing `jupyterlab` and any required python packages.
  - The `environment.yml` file from a minimal jupyter environment is configured in this repo at `conda-environment/jupyter/environment.yml`.

The default location for the spack installation, spack environment, and conda environment are defined in `form.yml`

## User-Controlled Environments

The app is set up to allow the use of a user-controlled Python environment, referred to as the "course" environment. This "course" environment uses a global spack install, but is set to use a conda environment created with the `--prefix` option. In our `script.sh.erb`, the path to this environment is determined by the course ID, so other applications will require changing the path to the environment. In our application, we use this to provide the option for course instructors to manage an environment from a shared folder for a course, while still having a Python environment maintained by system administrators as a fallback. If this behavior is not desired, the form can be modified to hard-code a global installation.

## Install

This repository should be added to the OnDemand app configuration. By default, this can be found at /var/www/ood/apps/sys.

Additionally, the spack and conda environments need to be installed:

```
$ JID=$(sbatch --mem=16g -c 8 installSpackEnvironment.sh conda)

$ sbatch --dependency=afterok:$JID --mem=16g -c 8 installCondaEnvironment.sh jupyter
```

For more details on the spack and conda environment install scripts, keep reading.

## Spack environment install script

The spack install process can take a long time, which is problematic when trying to maintain a terminal session. To assist, this repo includes a script to use with `sbatch` to install dependencies as a slurm job. The script is set up for use with the default global spack installation, but can be modified to activate whatever environment is desired.

With this script, the install process looks like this:
- Create a jupyter environment
- Add packages to the environment definition
- Run the `installSpackEnvironment.sh` script as an sbatch script to install the dependencies asynchronously
- Check on the progress of the job by tailing the log file or just seeing if the job is still running with `squeue`
- When the job finishes, verify that packages are present with `spack find` and check for errors in the log output files.

## Conda environment install script

The conda environment install process can also take some time, so a similar approach is recommended. The assumption is that all conda environments will share the same `conda` spack environment, although this is not strictly required.

To install the conda environment manually:

```
spack env activate -p conda
conda env create --file conda-environment/jupyter/environment.yml
```

Or run the utility script (preferably with `sbatch`):

```
./installCondaEnvironment.sh cs109a
```