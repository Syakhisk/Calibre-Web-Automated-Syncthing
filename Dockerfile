FROM crocodilestick/calibre-web-automated:V3.0.4

ARG SSH_PASSWORD

SHELL ["/bin/bash", "-c"]

RUN \
  echo "**** install: syncthing, ssh ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  sudo \
  openssh-server \
  nginx \
  syncthing

COPY --chown=abc:abc root/ /
RUN chown -R root:root /custom-cont-init.d/

# prepare calibre-web-automated directories for override
RUN \
  echo "**** setup: calibre-web-automated ****" && \
  install -d -o abc -g abc /app/calibre-web-automated

COPY --chown=abc:abc dirs.json /app/calibre-web-automated/dirs.json

# Syncthing
RUN \
  echo "**** setup: syncthing ****" && \
  install -d -o abc -g abc /var/lib/syncthing && \
  chmod +x /etc/s6-overlay/s6-rc.d/syncthing/run

# SSH Setup
COPY ssh/sshd_config /etc/ssh/sshd_config
RUN \
  echo "**** setup: ssh ****" && \
  usermod -aG sudo abc && \
  chsh -s /bin/bash abc && \
  ssh-keygen -A

# Nginx Setup
# Ensure Nginx runs with proper permissions
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN \
  echo "**** setup: nginx ****" && \
  chmod +x /etc/nginx/nginx.conf

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Syncthing Ports
EXPOSE 8384 22000/tcp 22000/udp 21027/UDP

# SSH Ports
EXPOSE 22

# Calibre Web UI
EXPOSE 8083
