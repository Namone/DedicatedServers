# Pull a Debian Linux distro.
FROM cm2network/steamcmd as server-base



FROM server-base as barotrauma-server


# Run Barotrauma on port 8000 (?)
EXPOSE 8000