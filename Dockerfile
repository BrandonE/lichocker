FROM ubuntu:16.04

WORKDIR /home/lichess

ADD run.sh /home/lichess/run.sh
ADD nginx.conf /usr/local/etc/nginx/nginx.conf

RUN apt-get update
RUN apt-get install -y apt-transport-https

# Add the MongoDB source.
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Add the Scala Build Tool source.
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

RUN apt-get update

RUN apt-get install -y curl default-jdk git-all mongodb-org nginx npm parallel sbt wget

# Silence the parallel citation warning.
RUN mkdir -p /root/.parallel
RUN touch /root/.parallel/will-cite

# Update node.
RUN npm install -g n
RUN n stable

# Link the nodejs executable so it can be used about Yarn.
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g yarn

RUN yarn global add gulp-cli

# Install svgcleaner via the Rust package manager, Cargo.
RUN curl https://sh.rustup.rs | sh -s -- -y
RUN /root/.cargo/bin/cargo install svgcleaner

# Create the MongoDB database directory.
RUN mkdir /data
RUN mkdir /data/db

EXPOSE 80

CMD ["./run.sh"]
