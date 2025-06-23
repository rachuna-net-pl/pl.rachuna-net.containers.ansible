FROM ubuntu:22.04

ARG CONTAINER_VERSION="0.0.0"

LABEL Author="Maciej Rachuna"
LABEL Application="pl.rachuna-net.containers.ansible"
LABEL Description="ansible container image"
LABEL version="${CONTAINER_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

COPY scripts/ /opt/scripts/

RUN apt-get update && apt-get install -y --no-install-recommends \
      ansible \
      bash \
      curl \
      git \
      jq \
      openssh-client \
      openssl \
      python3-pip \
      sshpass \
      sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
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
    && ansible-galaxy collection install community.general \
      --collections-path /usr/local/lib/python3.10/dist-packages/ansible_collections \
      --force \
    && ansible-galaxy collection install community.general:==7.2.0 \
      --collections-path /usr/local/lib/python3.10/dist-packages/ansible_collections \
      --force \
    && chmod +x /opt/scripts/*.bash

ENTRYPOINT [ "/opt/scripts/entrypoint.bash" ]
