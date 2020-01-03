FROM ubuntu:bionic-20191202

SHELL ["/bin/bash", "-c"]

RUN useradd -ms /bin/bash lichess \
    && apt-get update \
    && apt update \
    && apt-get install sudo \
    # Disable sudo login for the new lichess user.
    && echo "lichess ALL = NOPASSWD : ALL" >> /etc/sudoers

ENV TZ=Etc/GMT
RUN sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && sudo echo $TZ > /etc/timezone

# Run as a non-privileged user.
USER lichess

ADD build /home/lichess/build

RUN export HOME=/home/lichess \
  && sudo /home/lichess/build/node-init.sh \
  && sudo apt-key add /home/lichess/build/signatures/yarn.asc \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt-key add /home/lichess/build/signatures/mongodb-org.asc \
  && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
  && sudo apt-get update && sudo apt update \
  && sudo apt-get install -y \
  unzip \
  zip \
  nodejs \ 
  mongodb-org \ 
  parallel \ 
  && sudo apt install -y \ 
  yarn \
  redis-server \
  git-all \
  && /home/lichess/build/sdkman-init.sh \
  && source "$HOME/.sdkman/bin/sdkman-init.sh" \
  && sdk install java 13.0.1.hs-adpt && sdk install sbt \
  && sudo yarn global add gulp-cli \
  # Silence the parallel citation warning.
  && sudo mkdir -p ~/.parallel && sudo touch ~/.parallel/will-cite \
  # Make directories for mongodb
  && sudo mkdir -p /data/db && sudo chmod 666 /data/db \
  && sudo apt-get autoremove -y \
  && sudo apt-get clean \
  && sudo rm -rf /home/lichess/build

ADD run.sh /home/lichess/run.sh

# Use UTF-8 encoding.
ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

WORKDIR /home/lichess

ENTRYPOINT ./run.sh
