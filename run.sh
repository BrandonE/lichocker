#!/bin/sh
cd /home/lichess/projects/lila

# Use the default dev console script.
cp bin/dev.default bin/dev && chmod +x bin/dev

# Use the default application configuration.
cp conf/application.conf.default conf/application.conf

# Install the GeoLite2 database if we haven't already.
if [ ! -e ./data/GeoLite2-City.mmdb ]; then
    ./bin/gen/geoip
fi

# Update the client side modules.
./ui/build

yarn install && ./bin/svg-optimize

# Compile the Scala application
./bin/dev compile

# Run the Scala application
./bin/dev
