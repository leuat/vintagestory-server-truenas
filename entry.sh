#!/bin/sh

# Ensure User and Group IDs
if [ ! "$(id -u vintagestory)" -eq "$UID" ]; then usermod -o -u "$UID" vintagestory ; fi
if [ ! "$(id -g vintagestory)" -eq "$GID" ]; then groupmod -o -g "$GID" vintagestory ; fi

# Update server

cd /data
wget https://cdn.vintagestory.at/gamefiles/$SERVER_BRANCH/vs_server_linux-x64_$SERVER_VERSION.tar.gz
tar xzf vs_server_linux-x64_*.tar.gz
rm vs_server_linux-x64_*.tar.gz
echo "$SERVER_VERSION" > .version
chown -R vintagestory:vintagestory /data

# Apply server configuration
serverconfig="/data/server-file/serverconfig.json"

if [ ! -f serverconfig ]; then
cp /tmp/default-serverconfig.json /data/server-file/serverconfig.json
fi

#make mods folder
if [ ! -d /data/server-file/Mods ]; then
  mkdir /data/server-file/Mods
fi

if [ -d /data/server-file/Mods ]; then
  mv -f /tmp/mods/* /data/server-file/Mods/
fi

# Start server
echo "Launching server..."
su vintagestory -s /bin/sh -p -c "dotnet VintagestoryServer.dll --dataPath /data/server-file"
