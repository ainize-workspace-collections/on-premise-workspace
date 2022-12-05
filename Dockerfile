ARG BASE_IMAGE=nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
FROM $BASE_IMAGE

RUN yes | unminimize

# setup non-root user.
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# copy scripts and make executable
COPY scripts/*.sh /tmp/scripts/
RUN chmod a+rwx /tmp/scripts/*.sh

# configure environment
ENV \
    CONDA_DIR=/opt/conda \
    CONDA_MIRROR=https://github.com/conda-forge/miniforge/releases/latest/download  \
    CONDA_DIR=/opt/conda \
    CONDA_ROOT=/opt/conda 

ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME="/home/${USERNAME}"


RUN \
    apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    /bin/bash /tmp/scripts/common-ubuntu.sh && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/library-scripts

ARG PYTHON_VERSION=3.9
# Install Mamba
RUN /bin/bash /tmp/scripts/mamba.sh

ARG PASSWORD="P@ssw0rd1"
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN env > /etc/environment

RUN mkdir -p /run/sshd

USER $USERNAME
WORKDIR "/home/${USERNAME}"
RUN sudo ssh-keygen -t rsa -m pem -A
RUN sudo chsh -s $(which zsh) $USERNAME
# ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD ["/bin/zsh", "/tmp/scripts/start.sh"]