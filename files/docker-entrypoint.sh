#!/bin/bash
set -eoux pipefail


FCE_VOL=/FCE
LOAD_LATEST_SAVE="${LOAD_LATEST_SAVE:-true}"
GENERATE_NEW_SAVE="${GENERATE_NEW_SAVE:-false}"
WORLD_NAME="${SAVE_NAME:-""}"


mkdir -p "$FCE_VOL"
mkdir -p "$SAVES"
mkdir -p "$CONFIG"
mkdir -p "$MODS"

#if [[ ! -f $CONFIG/rconpw ]]; then
  # Generate a new RCON password if none exists
  #pwgen 15 1 >"$CONFIG/rconpw"
#fi


if [[ ! -f $CONFIG/firstrun.ini ]]; then
  # Copy default settings if server-settings.json doesn't exist
  cp "/opt/FCE/Default/Example Server Ini files/firstrun.ini" "$CONFIG/firstrun.ini"
fi

if [[ ! -f $CONFIG/serveroverrides.ini ]]; then
  # Copy default settings if server-settings.json doesn't exist
  cp "/opt/FCE/Default/Example Server Ini files/serveroverrides.ini" "$CONFIG/serveroverrides.ini"
fi


#if [[ ${UPDATE_MODS_ON_START:-} == "true" ]]; then
#  ./docker-update-mods.sh
#fi



if [[ $(id -u) = 0 ]]; then
  # Update the User and Group ID based on the PUID/PGID variables
  usermod -o -u "$PUID" FCE
  groupmod -o -g "$PGID" FCE
  # Take ownership of factorio data if running as root
  chown -R FCE:FCE "$FCE_VOL"
  # Drop to the factorio user
  SU_EXEC="su-exec FCE"
else
  SU_EXEC=""
fi


#sed -i '/write-data=/c\write-data=\/FCE/' /opt/FCE/config/config.ini
cd /opt/FCE/
./FC_Linux_Universal.x86_64 -batchmode
