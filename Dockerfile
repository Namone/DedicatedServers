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


RUN chown -R steam:steam /home
RUN chown -R barouser:barouser /home/barotrauma-data
RUN chown -R pzuser:pzuser /home/zomboid-data

# USER steam
WORKDIR /home/steam

#### Configure Barotrauma Server & related dependenices for the environment it runs within. #####
FROM server-base as barotrauma-server

# USER barouser

# Linux Barotrauma dependencies.
RUN mkdir /home/steam/.local
RUN mkdir /home/steam/.local/share
RUN mkdir /home/steam/.local/share/Daedalic\ Entertainment\ GmbH
RUN mkdir /home/steam/.local/share/Daedalic\ Entertainment\ GmbH/Barotrauma

RUN /usr/games/steamcmd +force_install_dir /home/barotrauma-data +login anonymous +app_update 1026340 validate +quit

# Run Barotrauma on port 27015; query port at 27016.
EXPOSE 27015
# EXPOSE 27016

FROM server-base as zomboid-server

RUN mkdir /home/pzuser/.steam

RUN /usr/games/steamcmd +force_install_dir /home/zomboid-data +login anonymous +app_update 380870 validate +quit

EXPOSE 16262