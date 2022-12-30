# Pull in Ubuntu.
FROM  ubuntu:20.04 as server-base


# Auto-accept Steam license agreement.
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections

RUN apt-get update -y
RUN apt-get install software-properties-common -y

RUN dpkg --add-architecture i386
RUN add-apt-repository multiverse

RUN apt-get update -y
RUN apt-get install steamcmd -y

USER root
RUN mkdir /games
RUN mkdir /games/save-data
RUN mkdir /internal
WORKDIR /

FROM server-base as zomboid-server

RUN mkdir /internal/ZomboidInstall
RUN /usr/games/steamcmd +force_install_dir /internal/ZomboidInstall +login anonymous +app_update 380870 validate +quit
COPY internal/start-zomboid-server.sh /internal/start-zomboid-server.sh
RUN mkdir /internal/Zomboid

COPY internal/Zomboid /internal
COPY internal/ProjectZomboid64.json /internal/ZomboidInstall/ProjectZomboid64.json

RUN mkdir /games/save-data/Zomboid

RUN mkdir /games/zomboid
WORKDIR /games/zomboid

EXPOSE 16261
EXPOSE 16262

FROM server-base as valheim-server

RUN mkdir /internal/ValheimInstall
RUN /usr/games/steamcmd +force_install_dir /internal/ValheimInstall +login anonymous +app_update 896660 validate +quit
COPY internal/valheim/valuser/start-valheim-server.sh /internal/start-valheim-server.sh
COPY internal/valheim/Valheim /internal/Valheim

RUN mkdir /games/valheim
WORKDIR /games/valheim

EXPOSE 2456
EXPOSE 2457