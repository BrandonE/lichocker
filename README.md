# lichocker - [lichess.org](https://lichess.org) run in a [https://www.docker.com/](Docker) container

## Getting Started

* [https://git-scm.com/downloads](Install Git).
* [https://docs.docker.com/install/](Install Docker).
* Check out [https://github.com/ornicar/lila](lila), the main project behind Lichess:

`git clone --recursive https://github.com/ornicar/lila.git`

* Add the following line to your `/etc/hosts` file: `127.0.0.1 l.org socket.l.org en.l.org`.

* Build the Docker image:

`docker build -t lichess .`

* Run lila in a Docker container using this image, replacing the path to your local lila repository in the following command:

```
docker run \
    -v ~/YOUR/PATH/TO/lila:/root/projects/lila \
    -p 80:80 \
    lichess
```

* Type `run` when you see the [https://www.scala-sbt.org/](Scala Build Tool) console appear: `[lila] $`.

* Wait until you see the following message:

```
--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.NettyServer - Listening for HTTP on /0:0:0:0:0:0:0:0:9663

(Server started, use Ctrl+D to stop and go back to the console...)
```

* Navigate to http://l.org in your host machine's browser.
