FROM ubuntu:16.04

RUN useradd -ms /bin/bash lichess \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    # Add the MongoDB source.
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
    && echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" \
        | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
    # Add the Scala Build Tool source.
    && echo "deb https://dl.bintray.com/sbt/debian /" \
        | tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && apt-get update \
    && apt-get install -y \
        curl \
        default-jdk \
        git-all \
        locales \
        mongodb-org \
        nginx \
        npm \
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
    # Link the nodejs executable so it can be used about Yarn.
    && ln -s /usr/bin/nodejs /usr/bin/node \
    && npm install -g yarn \
    && yarn global add gulp-cli \
    # Install svgcleaner via the Rust package manager, Cargo.
    && curl https://sh.rustup.rs \
        | sh -s -- -y \
    && /root/.cargo/bin/cargo install svgcleaner \
    # Move the svgcleaner executable to a folder in the system's path.
    && mv /root/.cargo/bin/svgcleaner /usr/bin/svgcleaner \
    # Create the MongoDB database directory.
    && mkdir /data \
    && mkdir /data/db \
    && sbt update \
    # Remove now unneeded dependencies.
    && apt-get purge -y \
        curl \
        git-all \
        npm \
    && apt-get autoremove -y \
    && apt-get clean \
    && /root/.cargo/bin/rustup self uninstall -y

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
