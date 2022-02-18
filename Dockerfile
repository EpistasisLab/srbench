FROM --platform=linux/amd64 mambaorg/micromamba:0.21.2 as build

################################################################################
# Nvidia code ##################################################################
################################################################################
ENV PATH /usr/local/nvidia/bin/:$PATH
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH
# Tell nvidia-docker the driver spec that we need as well as to
# use all available devices, which are mounted at /usr/local/nvidia.
# The LABEL supports an older version of nvidia-docker, the env
# variables a newer one.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
LABEL com.nvidia.volumes.needed="nvidia_driver"
################################################################################

# Install base packages.
USER root

RUN apt update && apt install -y \
    default-jdk \
    bzip2 \
    ca-certificates \
    curl \
    git \
    wget \
    vim \
    jq && \
    rm -rf /var/lib/apt/lists/*

# Install env
USER $MAMBA_USER
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml
RUN micromamba create -y -f /tmp/environment.yml \
    && micromamba clean --all --yes
ENV CONDA_PREFIX $MAMBA_ROOT_PREFIX
# conda is currently only needed for PySR
RUN micromamba install -y --name base -c conda-forge conda
# ENV PATH=$PATH:/opt/conda/bin
 # RUN echo 'export PATH=$PATH:/opt/conda/bin' >> ~/.bashrc

SHELL ["micromamba", "run", "-n", "srbench", "/bin/bash", "-c"]

# Always run inside srbench:
# RUN source ~/.bashrc && conda init bash
# RUN echo "conda activate srbench" >> ~/.bashrc

# Copy remaining files and install
COPY --chown=$MAMBA_USER:$MAMBA_USER . .
# RUN source ~/.bashrc && source install.sh
# RUN bash configure.sh
RUN ls
RUN /tmp/install.sh

COPY --chown=$MAMBA_USER:$MAMBA_USER . .
CMD ["/bin/bash", "-c"]
# CMD ["/bin/bash", "--login"]