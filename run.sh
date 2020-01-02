#!/bin/bash
source /home/lichess/.zshrc

# Run Redis in the background.
redis-server --daemonize yes

cd /home/lichess/projects/lila-ws

# Run lila-ws in the background.
setsid nohup sbt run &

# Run MongoDB in the background.
sudo mongod --fork --logpath /var/log/mongod.log

cd /home/lichess/projects/lila

# Update the client side modules.
./ui/build

# Run the Scala application
./lila run
