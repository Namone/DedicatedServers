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

# Link steamcmd
RUN ln -s /usr/games/steamcmd steamcmd
RUN useradd -m steam && useradd -m barouser && useradd -m pzuser

RUN usermod --password $(echo "root" | openssl passwd -1 -stdin) steam

RUN wget archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.10_amd64.deb && dpkg -i libssl1.0.0_1.0.2n-1ubuntu5.10_amd64.deb
RUN mkdir /home/barotrauma-data
RUN mkdir /home/zomboid-data

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

RUN chown -R steam:steam /home/steam
RUN chown -R barouser:barouser /home/steam/barotrauma-data

USER barouser

# Run Barotrauma on port 27015; query port at 27016.
EXPOSE 27015
EXPOSE 27016

FROM server-base as zomboid-server

# Define the Zomboid server configuration as a service in SystemCtl.
RUN mkdir /home/steam/Zomboid

RUN /usr/games/steamcmd +force_install_dir /home/steam/zomboid-data +login anonymous +app_update 380870 validate +quit

RUN chown -R steam:steam /home/steam
RUN chown -R pzuser:pzuser /home/steam/zomboid-data

USER steam

EXPOSE 16261
EXPOSE 16262