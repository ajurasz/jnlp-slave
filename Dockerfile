FROM jenkins/jnlp-slave:3.35-5-jdk11

USER root

# Install docker-ce
RUN set -ex \
  && export DOCKER_VERSION=docker-18.06.2-ce.tgz \
  && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz $DOCKER_URL \
  && ls -lha /tmp/docker.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker /tmp/docker.tgz

# Install docker-compose
RUN set -ex \
  && export DOCKER_COMPOSE_VERSION=1.22.0 \
  && DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`" \
  && curl --silent --show-error --location --fail --retry 3 --output /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL \
  && chmod +x /usr/local/bin/docker-compose

# Install gradle
RUN set -ex \
  && export GRADLE_VERSION=5.6.2 \
  && GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/gradle.zip $GRADLE_URL \
  && unzip /tmp/gradle.zip -d /tmp/gradle \
  && mkdir -p /usr/local/gradle \
  && mv "/tmp/gradle/gradle-${GRADLE_VERSION}"/* /usr/local/gradle \
  && rm -rf /tmp/gradle /tmp/gradle.zip

ENV GRADLE_HOME=/usr/local/gradle
ENV PATH=$PATH:$GRADLE_HOME/bin
    
VOLUME ["/home/jenkins/.gradle/caches/"]

# Install node
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=10.16.3

RUN mkdir -p $NVM_DIR \
  && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
  && . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} \
  && . "$NVM_DIR/nvm.sh" &&  nvm use v${NODE_VERSION} \
  && . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install chromium
RUN set -ex \
  && apt-get update \
  && apt-get install -y chromium

USER jenkins

ENTRYPOINT ["jenkins-slave"]
