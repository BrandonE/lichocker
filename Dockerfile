FROM ubuntu:bionic-20190912.1

ADD build /root/build

RUN useradd -ms /bin/bash lichess \
    && apt-get update \
    # Add custom sources for MongoDB and Scala.
    && apt-get install -y ca-certificates gnupg2 \
    && apt-key add /root/build/signatures/mongodb-org.asc \
    && apt-key add /root/build/signatures/sbt.asc \
    && rm -rf /root/build/signatures \
    && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" \
        | tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
    && echo "deb https://dl.bintray.com/sbt/debian /" | \
        tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git-all \
        locales \
        mongodb-org \
        nginx \
        npm \
        openjdk-8-jre-headless \
        parallel \
        sbt \
        sudo \
        wget \
    # Disable sudo login.
    && echo "lichess ALL = NOPASSWD : ALL" >> /etc/sudoers \
    # Set locale.
    && locale-gen en_US.UTF-8 \
    # Silence the parallel citation warning.
    && mkdir -p /home/lichess/.parallel \
    && touch /home/lichess/.parallel/will-cite \
    # Update node.
    && npm install -g n \
    && n stable \
    && npm install -g yarn \
    && yarn global add gulp-cli \
    # Install svgcleaner via the Rust package manager, Cargo.
    && /root/build/rustup-init.sh -y \
    && /root/.cargo/bin/cargo install svgcleaner \
    # Move the svgcleaner executable to a folder in the system's path.
    && mv /root/.cargo/bin/svgcleaner /usr/bin/svgcleaner \
    # Create the MongoDB database directory.
    && mkdir /data \
    && mkdir /data/db \
    && sbt update \
    # Remove now unneeded dependencies.
    && apt-get purge -y \
        git-all \
        gnupg2 \
        npm \
    && apt-get autoremove -y \
    && apt-get clean \
    && /root/.cargo/bin/rustup self uninstall -y \
    && rm -rf /root/build

ADD run.sh /home/lichess/run.sh
ADD nginx.conf /etc/nginx/nginx.conf

# Use UTF-8 encoding.
ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

# Run as a non-privileged user.
USER lichess

EXPOSE 80

WORKDIR /home/lichess

ENTRYPOINT ./run.sh
