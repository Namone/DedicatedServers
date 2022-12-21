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
RUN mkdir /internal
RUN mkdir /save-data
WORKDIR /

FROM server-base as zomboid-server

COPY internal/start-zomboid-server.sh /internal/start-zomboid-server.sh
RUN mkdir /internal/Zomboid

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