# lichocker - [lichess.org](https://lichess.org) run in a [Docker](https://www.docker.com/) container

## Prerequisites

* [Install Git](https://git-scm.com/downloads).
* [Install Docker](https://docs.docker.com/install/]).
* Check out [lila](https://github.com/ornicar/lila), the main project behind Lichess:

`git clone --recursive https://github.com/ornicar/lila.git`

* Add the following line to your `/etc/hosts` file: `127.0.0.1 l.org socket.l.org en.l.org`.

## Obtaining the Docker image
* Change directories to the lichocker repository and build the Docker image:

```
cd /YOUR/PATH/TO/lichocker
docker build -t lichess .
```

## Running

* Run lila in a Docker container using this image, replacing the path to your local lila repository in the following command:

```
docker run \
    -v ~/YOUR/PATH/TO/lila:/root/projects/lila \
    -p 80:80 \
    lichess
```

You can change the first `80` to some other other port number to bind the HTTP server to that port on the host machine.

* Type `run` when you see the [Scala Build Tool](https://www.scala-sbt.org/) console appear: `[lila] $`.

* Wait until you see the following message:

```
--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.NettyServer - Listening for HTTP on /0:0:0:0:0:0:0:0:9663

(Server started, use Ctrl+D to stop and go back to the console...)
```

* Navigate to http://l.org in your host machine's browser.

## Rebuilding Lichess

Because your lila directory exists on your host machine and is mounted onto the container, you can modify the code and rebuild on the host machine and it will take effect on the container. Run `~/YOUR/PATH/TO/lila/ui/build` to update the client side modules. Auto-reloading is enabled for the server side Scala code via sbt.

For more information, including the guide used to create lichocker, please see the [Lichess Development Onboarding](https://github.com/ornicar/lila/wiki/Lichess-Development-Onboarding) instructions.
