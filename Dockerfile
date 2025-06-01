FROM crocodilestick/calibre-web-automated:V3.0.4

ARG SSH_PASSWORD

SHELL ["/bin/bash", "-c"]

RUN \
  echo "**** install syncthing and ssh ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  sudo \
  openssh-server \
  syncthing

COPY --chown=abc:abc root/ /
RUN chown -R root:root /custom-cont-init.d/

# Syncthing
RUN \
  echo "**** syncthing ****" && \
  install -d -o abc -g abc /var/lib/syncthing && \
  chmod +x /etc/s6-overlay/s6-rc.d/syncthing/run

# SSH Setup
COPY ssh/sshd_config /etc/ssh/sshd_config
RUN usermod -aG sudo abc && \
  chsh -s /bin/bash abc && \
  ssh-keygen -A

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Syncthing Ports
EXPOSE 8384 22000/tcp 22000/udp 21027/UDP

# SSH Ports
EXPOSE 22

# Calibre Web UI
EXPOSE 8083
