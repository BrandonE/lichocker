# lichocker - [lichess.org](https://lichess.org) run in a [Docker](https://www.docker.com/) container

## Prerequisites

* [Install Git](https://git-scm.com/downloads).
* [Install Docker](https://docs.docker.com/install/]).
* Recommended: Increase your Docker runtime memory to 4GB and your CPUs to 4 ([Mac](https://docs.docker.com/docker-for-mac/#advanced), [Windows](https://docs.docker.com/docker-for-windows/#advanced), and configure the `docker-machine` assigned memory and CPUs for VirtualBox).
* Check out [lila](https://github.com/ornicar/lila), the main project behind Lichess: `git clone --recursive https://github.com/ornicar/lila.git`
* Use the default dev console script: `cp bin/dev.default bin/dev && chmod +x bin/dev`
* Use the default application configuration: `cp conf/application.conf.default conf/application.conf`
* Add the following line to your `/etc/hosts` file: `127.0.0.1 l.org socket.l.org en.l.org`

## Obtaining the Docker image
* Change directories to the lichocker repository and build the Docker image:

```
cd /YOUR/PATH/TO/lichocker
docker build --tag lichess .
```

## Running

* Run lila in a Docker container using this image, replacing the path to your local lila repository in the following command:

```
docker run \
    --volume ~/YOUR/PATH/TO/lila:/home/lichess/projects/lila \
    --publish 80:80 \
    --name lichess \
    --interactive \
    --tty \
    lichess
```

You can change the first `80` to some other other port number to bind the HTTP server to that port on the host machine. You will also have to change `net.asset.domain` in your lila config.

* Type `run` when you see the [Scala Build Tool](https://www.scala-sbt.org/) console appear: `[lila] $`

* Wait until you see the following message:

```
--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.NettyServer - Listening for HTTP on /0.0.0.0:9663

(Server started, use Ctrl+D to stop and go back to the console...)
```

* Navigate to http://l.org in your host machine's browser.

### Optional: Setup fishnet for server side analysis and play

You can run fishnet (in another Docker container if desired) by following [https://github.com/niklasf/fishnet](these instructions).

## Rebuilding Lichess

Because your lila directory exists on your host machine and is mounted onto the container, you can modify the code and rebuild on the host machine and it will take effect on the container. Run `~/YOUR/PATH/TO/lila/ui/build` to update the client side modules. Auto-reloading is enabled for the server side Scala code via sbt.

For more information, including the guide used to create lichocker, please see the [Lichess Development Onboarding](https://github.com/ornicar/lila/wiki/Lichess-Development-Onboarding) instructions.

## Other Commands

* Exiting the Docker container: Ctrl+C
* Stopping the Docker container: `docker stop lichess`
* Restarting the Docker container: `docker start lichess --attach --interactive`
* View the output of the running Docker container that you previously exited: `docker attach lichess`
* Remove the Docker container to mount a different volume or change the host port: `docker rm lichess`
