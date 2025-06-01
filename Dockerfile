FROM crocodilestick/calibre-web-automated:V3.0.4

# ARG SSH_USER
# ARG SSH_PASSWORD

SHELL ["/bin/bash", "-c"]

RUN \
  echo "**** install syncthing and ssh ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  openssh-server \
  syncthing


COPY --chown=abc:abc root/ /

RUN \
  echo "**** syncthing ****" && \
  install -d -o abc -g abc /var/lib/syncthing && \
  chmod +x /etc/s6-overlay/s6-rc.d/syncthing/run

# TODO: put this at bottom along with other EXPOSE
EXPOSE 8384 22000/tcp 22000/udp 21027/UDP

# RUN echo "abc:${SSH_PASSWORD}}" | chpasswd
#
# RUN \
#   echo "**** syncthing setup ****" && \
#   cp -R /app/additionals/root/* / && \
#   chmod +x /etc/s6-overlay/s6-rc.d/syncthing/run && \
#   chmod +x /etc/s6-overlay/s6-rc.d/sshd/run
#
# # Set up SSH config
# RUN \
#   sed -i 's/#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
#   sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
#
# # # Create s6 service for Syncthing
# # RUN mkdir -p /etc/services.d/syncthing
# # COPY syncthing/run /etc/services.d/syncthing/run
# # RUN chmod +x /etc/services.d/syncthing/run
#
# # RUN apt-get clean && \
# #   rm -rf /var/lib/apt/lists/* && \
# #   rm -rf /app/additionals && \
#
# # Calibre Web UI
# EXPOSE 8083
#
# # SSH
# EXPOSE 22
#
# # Syncthing Web UI
# EXPOSE 8384
#
# # Syncthing sync
# EXPOSE 22000/tcp
#
# # Syncthing discovery
# EXPOSE 21027/udp
