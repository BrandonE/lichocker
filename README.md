# lichocker - [lichess.org](https://lichess.org) run as a [Docker](https://www.docker.com/) container stack

## Prerequisites

* [Install Git](https://git-scm.com/downloads).
* [Install Docker](https://docs.docker.com/install/).
* [Install Docker Compose](https://docs.docker.com/compose/install/).
* *Recommended*: Increase your Docker runtime memory to 4GB and your CPUs to 4 ([Mac](https://docs.docker.com/docker-for-mac/#advanced), [Windows](https://docs.docker.com/docker-for-windows/#advanced), and configure the `docker-machine` assigned memory and CPUs for VirtualBox).
* Check out lichocker (`git clone https://github.com/BrandonE/lichocker`) and open the directory in your terminal: `cd /YOUR/PATH/TO/lichocker`
* Check out [lila](https://github.com/ornicar/lila), the main project behind Lichess: `git clone --recursive https://github.com/ornicar/lila.git`
* Check out [lila-ws](https://github.com/ornicar/lila-ws), which manages Websockets. `git clone https://github.com/ornicar/lila-ws.git`
* Add the following line to your `/etc/hosts` file: `127.0.0.1 lichess-assets.local`

## Running

* lila and lila-ws source codes must be available to the containers. Hence, you must export their location in the `.env` file. By default, they reference the parent directory.

* To start the stack with `mongodb`, `redis`, `lila-ws` and `lila`, simply call `docker-compose`:

```
docker-compose up
```

* Wait until you see the following message:

```
--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.AkkaHttpServer - Listening for HTTP on /0.0.0.0:9663

(Server started, use Enter to stop and go back to the console...)
```

* Navigate to http://localhost:9663 in your host machine's browser.

### Optional: Setup fishnet for server side analysis and play

You can run fishnet (in another Docker container if desired) by following [these instructions](https://github.com/niklasf/fishnet).

## Viewing the logs

To view the logs, you can use docker or docker-compose. Here is how you can easily do so with docker-compose:

1. Open a new terminal
2. Navigate to lichocker
3. Run the command to view the logs
   ```
   docker-compose logs <NAME_OF_THE_SERVICE>
   ```
   example:
   ```
   docker-compose logs lila
   ```
   Add `-f` after logs for tailing (`docker-compose logs -f lila`).

> **_NOTE:_** If you don't want to run multiple terminals open at once, instead of running docker-compose in foreground, do so in background by adding the `-d` option: `docker-compose up -d`

## Rebuilding Lichess

Because your lila directory exists on your host machine and is mounted onto the container, you can modify the code and rebuild on the host machine and it will take effect on the container. Run `/YOUR/ABSOLUTE/PATH/TO/lila/ui/build` to update the client side modules. Auto-reloading is enabled for the server side Scala code via sbt.

For more information, including the guide used to create lichocker, please see the [Lichess Development Onboarding](https://github.com/ornicar/lila/wiki/Lichess-Development-Onboarding) instructions.

## Other Commands

* Exiting Docker Compose in the foreground: `CTRL+C`
* Exiting Docker Compose in the background: `docker-compose down`