#!/bin/sh

# Ensure User and Group IDs
if [ ! "$(id -u vintagestory)" -eq "$UID" ]; then usermod -o -u "$UID" vintagestory ; fi
if [ ! "$(id -g vintagestory)" -eq "$GID" ]; then groupmod -o -g "$GID" vintagestory ; fi


cd /data
chown -R vintagestory:vintagestory /data

# Update server
if [ ! -f /data/vs_server_linux-x64_$SERVER_VERSION.tar.gz ]; then
  wget https://cdn.vintagestory.at/gamefiles/$SERVER_BRANCH/vs_server_linux-x64_$SERVER_VERSION.tar.gz
  tar xzf vs_server_linux-x64_*.tar.gz
fi


# Copy Default serverconfig.json
if [ ! -f /data/server-file/serverconfig.json ]; then
cp /tmp/default-serverconfig.json /data/server-file/serverconfig.json
fi


# Make Mods directory
if [ ! -d /data/server-file/Mods ]; then
  mkdir /data/server-file/Mods
fi


# Move mods to Mods directory
if [ -d /data/server-file/Mods ]; then
  mv -f /tmp/mods/* /data/server-file/Mods/
fi


# Start server
echo "Launching server..."
su vintagestory -s /bin/sh -p -c "dotnet VintagestoryServer.dll --dataPath /data/server-file"
