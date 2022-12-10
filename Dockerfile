# Pull a Debian Linux distro.
FROM cm2network/steamcmd as server-base



FROM server-base as barotrauma-server

RUN ./steamcmd.sh +force_install_dir /home/steam/steamcmd/barotrauma-data +login anonymous +app_update 1026340  +quit
# Run Barotrauma on port 8000 (?)
EXPOSE 8000