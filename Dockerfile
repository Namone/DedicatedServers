# Pull a Debian Linux distro.
FROM  ubuntu:20.04 as server-base


# Auto-accept Steam license agreement.
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections


RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt-get update -y
# RUN apt-get install --reinstall libcairomm-1.0-1v5 libglibmm-2.4-1v5 \
# libsigc++-2.0-0v5
# Link steamcmd
RUN apt-get install steam steamcmd -y

USER root
RUN mkdir /internal
WORKDIR /

#### Configure Barotrauma Server & related dependenices for the environment it runs within. #####
FROM goldfish92/barotrauma-dedicated-server:1.2.0 as barotrauma-server

USER root

COPY internal/Barotrauma /internal/Barotrauma

FROM server-base as zomboid-server

COPY internal/start-zomboid-server.sh /internal/start-zomboid-server.sh

COPY internal/Zomboid /internal/Zomboid

USER root

WORKDIR /zomboid

EXPOSE 16261
EXPOSE 16262

FROM server-base as valheim-server


COPY internal/valheim/valuser/start-valheim-server.sh /internal/start-valheim-server.sh
COPY internal/valheim/Valheim /internal/Valheim

WORKDIR /valheim

EXPOSE 2456
EXPOSE 2457