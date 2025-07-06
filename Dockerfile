FROM ubuntu:noble

ARG CONTAINER_VERSION="0.0.0"

LABEL Author="Maciej Rachuna"
LABEL Application="pl.rachuna-net.containers.ansible"
LABEL Description="ansible container image"
LABEL version="${CONTAINER_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

COPY scripts/ /opt/scripts/

# Install system dependencies and ansible
RUN apt-get update && apt-get install -y --no-install-recommends \
      ansible \
      bash \
      curl \
      git \
      jq \
      openssl \
      openssh-client \
      python-is-python3 \
      python3 \
      python3-pip \
      python3-setuptools \
      python3-venv \
      sshpass \
      sudo \
    && rm -rf /var/lib/apt/lists/* \

# Upgrade pip and install Python packages in one command to reduce layers
    && pip3 install --no-cache-dir --break-system-packages --ignore-installed \
        ansible \
        ansible-core \
        ansible-lint \
        hvac \
        molecule==25.1.0 \
        molecule-plugins \
        molecule-proxmox \
        pytest-testinfra \
        requests \
        testinfra \

# Install ansible galaxy collections
    && ansible-galaxy collection install community.general:==7.2.0 \
        --collections-path /usr/local/lib/python3.10/dist-packages/ansible_collections \
        --force \

# Make scripts executable
    && chmod +x /opt/scripts/*.bash \

# Create a non-root user and set permissions
    && useradd -m -s /bin/bash ansible \
    && chown -R ansible:ansible /opt/scripts

USER ansible

ENTRYPOINT [ "/opt/scripts/entrypoint.bash" ]
