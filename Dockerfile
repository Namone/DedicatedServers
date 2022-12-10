# Pull a Debian Linux distro.
FROM steamcmd/steamcmd:ubuntu-18 as server-base

#### Configure Barotrauma Server & related dependenices for the environment it runs within. #####
FROM server-base as barotrauma-server

# CentOS/non-debian Linux Barotrauma dependency.
# RUN yum install openssl-devel -y
# Make path for server to use (defined in Barotrauma server setup wiki.)
RUN mkdir ~/.local
RUN mkdir ~/.local/share
RUN mkdir ~/.local/share/Daedalic\ Entertainment\ GmbH
RUN mkdir  ~/.local/share/Daedalic\ Entertainment\ GmbH/Barotrauma

RUN apt-get update && apt-get install libsdl2-dev --fix-missing -y

RUN steamcmd +force_install_dir /home/barotrauma-data +login anonymous +app_update 1026340 +quit

# Run Barotrauma on port 27015; query port at 27016.
EXPOSE 27015
# EXPOSE 27016