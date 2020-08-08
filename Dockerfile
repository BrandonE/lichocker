ARG OPENJDK_TAG=14.0.2-jdk-buster
FROM openjdk:${OPENJDK_TAG}

ARG SBT_VERSION=1.3.13

RUN if [ -z "$(command -v yum)" ] ; \
    then \
        curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
        dpkg -i sbt-$SBT_VERSION.deb && \
        rm sbt-$SBT_VERSION.deb && \
        apt-get update && \
        apt-get install sbt && \
        sbt sbtVersion; \
    else \
        curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
        yum update && \
        yum install -y sbt-$SBT_VERSION && \
        sbt sbtVersion; \
    fi

ARG YARN_VERSION=1.22.4

RUN apt-get update && apt-get install -y gnupg2 && \
    apt-get install -y apt-transport-https ca-certificates && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn=${YARN_VERSION}-1 && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    yarn global add gulp

ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"
ENV TZ=Etc/GMT

WORKDIR /home/lichess

ADD run.sh .
