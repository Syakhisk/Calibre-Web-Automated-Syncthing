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

# Update library
RUN \
  echo "**** setup: update-library ****" && \
  mkdir -p /custom/ && \
  chmod +x /etc/s6-overlay/s6-rc.d/update-library/run

COPY --chown=abc:abc dirs.json /custom/dirs.json

# Syncthing
RUN \
  echo "**** setup: syncthing ****" && \
  install -d -o abc -g abc /var/lib/syncthing && \
  chmod +x /etc/s6-overlay/s6-rc.d/syncthing/run

# Filebrowser Setup
RUN \
  echo "**** setup: filebrowser ****" && \
  curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
  chmod +x /etc/s6-overlay/s6-rc.d/filebrowser/run

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

# Filebrowser Ports
EXPOSE 8080

# Calibre Web UI
EXPOSE 8083

# Nginx Ports
EXPOSE 80
