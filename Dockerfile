FROM frolvlad/alpine-glibc:alpine-3.12
FROM steamcmd/steamcmd:latest

LABEL maintainer="Dakes but not forever!"

ARG USER=FCE
ARG GROUP=FCE
ARG PUID=845
ARG PGID=845


ENV PORT=27012  \
    RCON_PORT=27015  \
    BRANCH=linux-staging \
    STEAM_ID=443600 \
    SAVES=/FCE/Worlds \
    CONFIG=/FCE/Config \
    MODS=/FCE/WorkshopMods \
    SCRIPTOUTPUT=/factorio/script-output \
    PUID="$PUID" \
    PGID="$PGID" \
    USER=FCE \
    GROUP=FCE \
    HOME=/home/FCE

RUN addgroup --gid "$PGID" --system "$GROUP" \
    && adduser --uid "$PUID" --shell "/bin/sh" --system --ingroup $GROUP "$USER" \
    && mkdir -p mkdir -p /opt/FCE \
    && mkdir -p mkdir -p /FCE \
    && chown -R "$USER":"$GROUP" /opt/FCE /FCE

RUN chown -R "$USER":"$GROUP" /opt/FCE
RUN chown -R "$USER":"$GROUP" /FCE

# Using the user caused problems, that I couldn't fix, so for now just use root. 
# USER FCE

RUN mkdir -p $HOME/.config/ \
    && mkdir -p $HOME/.config/unity3d/ \
    && mkdir -p $HOME/.config/unity3d/ProjectorGames/ \
    && mkdir -p $HOME/.config/unity3d/ProjectorGames/FortressCraft/ \
    && mkdir -p /opt/FCE/Default/ \
    #  ln -s original link
    && ln -s $SAVES $HOME/.config/unity3d/ProjectorGames/FortressCraft/Worlds   \
    && ln -s $CONFIG/serveroverrides.ini /opt/FCE/Default/serveroverrides.ini  \
    && ln -s $CONFIG/firstrun.ini /opt/FCE/Default/firstrun.ini  \
    && ln -s $MODS $HOME/.config/unity3d/ProjectorGames/FortressCraft/WorkshopMods \
    && ln -s "/FCE/Player.log" "$HOME/.config/unity3d/ProjectorGames/FortressCraft/Player.log" 


COPY files/*.sh /
COPY files/serveroverrides.ini $CONFIG/
COPY files/firstrun.ini $CONFIG/
COPY files/serveroverrides.ini /
COPY files/firstrun.ini /

# Don't install during container creation, but later. If you choose to use a external dir for the server data, those can be revalidated and don't have to be redownloaded on rebuild. 
# It also prevents the creation of a 5gb+ docker image, since the game server would be saved inside the server. 
#RUN set -ox pipefail \
#    && steamcmd @ShutdownOnFailedCommand 1 + @NoPromptForPassword 1 +login anonymous +force_install_dir "/opt/FCE/" +app_update 443600 validate -beta linux-staging  validate +quit

RUN mkdir -p /opt/FCE/server

VOLUME /FCE
VOLUME /opt/FCE

EXPOSE $PORT/udp $PORT/tcp $RCON_PORT/udp $RCON_PORT/tcp
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]
