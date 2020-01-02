FROM ubuntu:bionic-20191202

SHELL ["/bin/bash", "-c"]

RUN useradd -ms /bin/bash lichess \
    && apt-get update \
    && apt update \
    && apt-get install sudo \
    # Disable sudo login for the new lichess user.
    && echo "lichess ALL = NOPASSWD : ALL" >> /etc/sudoers

# Run as a non-privileged user.
USER lichess

ADD build /home/lichess/build

RUN export HOME=/home/lichess \
  && sudo apt-get install -y curl && sudo apt-get install -y gnupg2 && sudo apt-get install -y ca-certificates wget \
  && curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add \
  && curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - \
  && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
  && sudo apt-get update && sudo apt update \
  && sudo apt-get install -y unzip && sudo apt-get install -y zip && sudo apt-get install -y nodejs && sudo apt-get install -y mongodb-org && sudo apt-get install -y parallel && sudo apt install -y yarn && sudo apt install -y redis-server && sudo apt install -y git-all \
  && curl -s "https://get.sdkman.io" | bash \
  && source "$HOME/.sdkman/bin/sdkman-init.sh" \
  && sdk install java 13.0.1.hs-adpt && sdk install sbt \
  && sudo yarn global add gulp-cli \
  && sudo mkdir -p ~/.parallel && sudo touch ~/.parallel/will-cite \
  && sudo mkdir -p /data/db && sudo chmod 777 /data/db

ADD run.sh /home/lichess/run.sh

# Use UTF-8 encoding.
ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

EXPOSE 80

WORKDIR /home/lichess

ENTRYPOINT ./run.sh
