# lichocker - [lichess.org](https://lichess.org) run in a [Docker](https://www.docker.com/) container

## Prerequisites

* [Install Git](https://git-scm.com/downloads).
* [Install Docker](https://docs.docker.com/install/]).
* *Recommended*: Increase your Docker runtime memory to 4GB and your CPUs to 4 ([Mac](https://docs.docker.com/docker-for-mac/#advanced), [Windows](https://docs.docker.com/docker-for-windows/#advanced), and configure the `docker-machine` assigned memory and CPUs for VirtualBox).
* Check out lichocker and open the directory in your terminal: `cd /YOUR/PATH/TO/lichocker`
* Check out [lila](https://github.com/ornicar/lila), the main project behind Lichess: `git clone --recursive https://github.com/ornicar/lila.git`
* Check out [lila-ws](https://github.com/ornicar/lila-ws), which manages Websockets. `git clone https://github.com/ornicar/lila-ws.git`
* Add the following line to your `/etc/hosts` file: `127.0.0.1 lichess-assets.local`

## Obtaining the Docker image

### Building the image

Run the following while in the lichocker directory: `docker build --tag brandone211/lichess .`

### Retrieving from Docker Hub

```
docker login
docker pull brandone211/lichess
```

The Docker Hub repository can be found [here](https://hub.docker.com/r/brandone211/lichess/).

## Running

* Run lila in a Docker container using the image obtained above, replacing the path to your local lila repository in the following command:

```
docker run \
    --volume /YOUR/ABSOLUTE/PATH/TO/lila:/home/lichess/projects/lila \
    --volume /YOUR/ABSOLUTE/PATH/TO/lila-ws:/home/lichess/projects/lila-ws \
    --publish 80:80 \
    --publish 9663:9663 \
    --publish 9664:9664 \
    --name lichess \
    --interactive \
    --tty \
    brandone211/lichess
```

* Wait until you see the following message:

```
--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.NettyServer - Listening for HTTP on /0.0.0.0:9663

(Server started, use Ctrl+D to stop and go back to the console...)
```

* Navigate to http://localhost:9663 in your host machine's browser.

### Optional: Setup fishnet for server side analysis and play

You can run fishnet (in another Docker container if desired) by following [these instructions](https://github.com/niklasf/fishnet).

## Rebuilding Lichess

Because your lila directory exists on your host machine and is mounted onto the container, you can modify the code and rebuild on the host machine and it will take effect on the container. Run `/YOUR/ABSOLUTE/PATH/TO/lila/ui/build` to update the client side modules. Auto-reloading is enabled for the server side Scala code via sbt.

For more information, including the guide used to create lichocker, please see the [Lichess Development Onboarding](https://github.com/ornicar/lila/wiki/Lichess-Development-Onboarding) instructions.

## Other Commands

* Exiting the Docker container: Ctrl+C
* Stopping the Docker container: `docker stop lichess`
* Restarting the Docker container: `docker start lichess --attach --interactive`
* View the output of the running Docker container that you previously exited: `docker attach lichess`
* Remove the Docker container to mount a different volume: `docker rm lichess`
