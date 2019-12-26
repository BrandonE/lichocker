FROM ubuntu:bionic-20190912.1

RUN useradd -ms /bin/bash lichess \
    && apt-get update \
    && apt-get install sudo \
    # Disable sudo login for the new lichess user.
    && echo "lichess ALL = NOPASSWD : ALL" >> /etc/sudoers

# Run as a non-privileged user.
USER lichess

ADD build /home/lichess/build

RUN export PATH="/home/lichess/.cargo/bin:/home/lichess/.node/bin:/home/lichess/.node/lib/node_modules/bin:/home/lichess/.yarn/bin:$PATH" \
    && echo 'debconf debconf/frontend select Noninteractive' | \
        sudo debconf-set-selections \
    # Add custom sources for MongoDB and Scala.
    && sudo apt-get install -y ca-certificates gnupg2 \
    && sudo apt-key add /home/lichess/build/signatures/mongodb-org.asc \
    && sudo apt-key add /home/lichess/build/signatures/sbt.asc \
    && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" \
        | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
    && echo "deb https://dl.bintray.com/sbt/debian /" | \
        sudo tee -a /etc/apt/sources.list.d/sbt.list \
    && sudo apt-get update \
    && sudo apt-get install -y \
        default-jdk \
        git-all \
        locales \
        mongodb-org \
        nginx \
        npm \
        parallel \
        sbt \
        wget \
        redis-server \
    # Set locale.
    && sudo locale-gen en_US.UTF-8 \
    # Silence the parallel citation warning.
    && mkdir -p /home/lichess/.parallel \
    && touch /home/lichess/.parallel/will-cite \
    # Update node.
    && echo 'prefix = /home/lichess/.node' >> /home/lichess/.npmrc \
    && npm install -g n yarn \
    && N_PREFIX=/home/lichess/.node/lib/node_modules n 10.16.3 \
    && sudo rm /usr/bin/node \
    && yarn global add gulp-cli --prefix /home/lichess/.yarn \
    # Install svgcleaner via the Rust package manager, Cargo.
    && /home/lichess/build/rustup-init.sh -y \
    && cargo install svgcleaner \
    # Move the svgcleaner executable to a folder in the system's path.
    && sudo mv /home/lichess/.cargo/bin/svgcleaner /usr/bin/svgcleaner \
    # Create the MongoDB database directory.
    && sudo mkdir /data \
    && sudo mkdir /data/db \
    # Remove now unneeded dependencies.
    && sudo apt-get purge -y \
        git-all \
        gnupg2 \
        npm \
    && sudo apt-get autoremove -y \
    && sudo apt-get clean \
    && rustup self uninstall -y \
    && sudo rm -rf /home/lichess/build

ADD run.sh /home/lichess/run.sh
ADD nginx.conf /etc/nginx/nginx.conf

# Use UTF-8 encoding.
ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

ENV PATH "/home/lichess/.node/bin:/home/lichess/.node/lib/node_modules/bin:/home/lichess/.yarn/bin:${PATH}"

EXPOSE 80

WORKDIR /home/lichess

ENTRYPOINT ./run.sh
