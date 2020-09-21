FROM frolvlad/alpine-glibc:alpine-3.12
FROM steamcmd/steamcmd:latest

LABEL maintainer="Stinosko but not forever!"

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

USER FCE

COPY files/*.sh /

RUN mkdir -p $HOME/.config/ \
    && mkdir -p $HOME/.config/unity3d/ \
    && mkdir -p $HOME/.config/unity3d/ProjectorGames/ \
    && mkdir -p $HOME/.config/unity3d/ProjectorGames/FortressCraft/ \
    && mkdir -p /opt/FCE/Default/ \
    && ln -s $SAVES $HOME/.config/unity3d/ProjectorGames/FortressCraft/Worlds   \
    && ln -s $CONFIG/serveroverrides.ini /opt/FCE/Default/serveroverrides.ini  \
    && ln -s $CONFIG/firstrun.ini /opt/FCE/Default/firstrun.ini  \
    && ln -s $MODS $HOME/.config/unity3d/ProjectorGames/FortressCraft/WorkshopMods \
    && ln -s "/FCE/Player.log" "$HOME/.config/unity3d/ProjectorGames/FortressCraft/Player.log" 

RUN set -ox pipefail \
    && steamcmd @ShutdownOnFailedCommand 1 + @NoPromptForPassword 1 +login anonymous +force_install_dir "/opt/FCE/" +app_update 443600 -beta linux-staging  validate +quit 










VOLUME /FCE

EXPOSE $PORT/udp $RCON_PORT/udp
ENTRYPOINT ["/docker-entrypoint.sh"]


