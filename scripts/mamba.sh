#!/bin/bash
set -e

# Miniforge installer
miniforge_arch=$(uname -m) && \
miniforge_installer="Mambaforge-Linux-${miniforge_arch}.sh" && \
wget --quiet "${CONDA_MIRROR}/${miniforge_installer}" && \
/bin/bash "${miniforge_installer}" -f -b -p "${CONDA_DIR}" && \
rm "${miniforge_installer}" && \
# Conda configuration see https://conda.io/projects/conda/en/latest/configuration.html
conda config --system --set auto_update_conda false && \
conda config --system --set show_channel_urls true && \
mamba install --quiet --yes python="${PYTHON_VERSION}" && \
# Pin major.minor version of python
mamba list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned" && \
# Using conda to update all packages: https://github.com/mamba-org/mamba/issues/1092
mamba update --all --quiet --yes && \
mamba clean --all -f -y