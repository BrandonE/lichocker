#!/bin/sh
cd /home/lichess/projects/lila

# Run nginx.
sudo nginx

# Run MongoDB in the background.
sudo mongod --fork --logpath /var/log/mongod.log

# Install the GeoLite2 database if we haven't already.
if [ ! -e ./data/GeoLite2-City.mmdb ]; then
    ./bin/gen/geoip
fi

# Update the client side modules.
./ui/build

yarn install

# Compile the Scala application
./bin/dev compile

# Run the Scala application
./bin/dev
