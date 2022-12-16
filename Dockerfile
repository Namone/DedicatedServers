# Pull a Debian Linux distro.
FROM  ubuntu:20.04 as server-base


# Auto-accept Steam license agreement.
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections


RUN apt-get update && apt-get install wget openssl lib32gcc-s1 --fix-missing -y
RUN apt-get install software-properties-common -y
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt-get update -y
RUN apt-get install lib32gcc-s1 -y
RUN apt-get install steam steamcmd -y
# RUN apt-get install --reinstall libcairomm-1.0-1v5 libglibmm-2.4-1v5 \
# libsigc++-2.0-0v5
# Link steamcmd
RUN ln -s /usr/games/steamcmd steamcmd
RUN useradd -m steam && useradd -m barouser && useradd -m pzuser && useradd -m valuser

RUN usermod --password $(echo "root" | openssl passwd -1 -stdin) steam
RUN chown -R steam:steam /home
WORKDIR /home/steam

#### Configure Barotrauma Server & related dependenices for the environment it runs within. #####
FROM server-base as barotrauma-server

# USER barouser

# Linux Barotrauma dependencies.
RUN mkdir /home/steam/.local
RUN mkdir /home/steam/.local/share
RUN mkdir /home/steam/.local/share/Daedalic\ Entertainment\ GmbH
RUN mkdir /home/steam/.local/share/Daedalic\ Entertainment\ GmbH/Barotrauma

RUN /usr/games/steamcmd +force_install_dir /home/steam/barotrauma-data +login anonymous +app_update 1026340 validate +quit

RUN chown -R steam:steam /home
RUN chown -R barouser:barouser /home/barotrauma-data

USER barouser

# Run Barotrauma on port 27015; query port at 27016.
EXPOSE 27015
EXPOSE 27016

FROM server-base as zomboid-server

WORKDIR /home/pzuser

RUN /usr/games/steamcmd +force_install_dir /home/pzuser/zomboid-data +login anonymous +app_update 380870 validate +quit
RUN rm /home/pzuser/zomboid-data/start-server.sh
COPY internal/start-server.sh /home/pzuser/zomboid-data/start-server.sh

COPY internal/Zomboid /root/Zomboid

RUN chown -R pzuser:pzuser /home/pzuser

USER root

EXPOSE 16261
EXPOSE 16262

FROM server-base as valheim-server

WORKDIR /home/valuser

RUN mkdir /home/valuser/valheim-data
COPY internal/valheim /home/valuser/valheim-data
RUN chmod u+x /home/valuser/valheim-data

RUN /usr/games/steamcmd +force_install_dir /home/valuser/valheim-data +login anonymous +app_update 896660 validate +quit

RUN chown -R valuser:valuser /home/valuser

USER root

EXPOSE 2456
EXPOSE 2457