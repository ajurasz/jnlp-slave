FROM jenkins/jnlp-slave:3.35-5-jdk11

USER root

# Install docker-ce
RUN set -ex \
  && export DOCKER_VERSION=docker-18.06.2-ce.tgz \
  && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz "${DOCKER_URL}" \
  && ls -lha /tmp/docker.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker /tmp/docker.tgz

# Install gradle
RUN set -ex \
  && export GRADLE_VERSION=5.6.2 \
  && GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/gradle.zip "${GRADLE_URL}" \
  && unzip /tmp/gradle.zip -d /tmp/gradle \
  && mkdir -p /usr/local/gradle \
  && mv "/tmp/gradle/gradle-${GRADLE_VERSION}"/* /usr/local/gradle \
  && rm -rf /tmp/gradle /tmp/gradle.zip

ENV GRADLE_HOME=/usr/local/gradle
ENV PATH=$PATH:$GRADLE_HOME/bin
    
VOLUME ["/home/jenkins/.gradle/caches/"]

## Install chrome
RUN set -ex \
  && apt-get update \
  && apt-get install -y libasound2 libnspr4 libnss3 libxss1 xdg-utils libappindicator3-1 fonts-liberation lsb-release libgtk-3-0 libatspi2.0-0 libatk-bridge2.0-0 \
  && GOOGLE_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/google.deb "${GOOGLE_URL}" \
  && dpkg -i /tmp/google.deb \
  && rm -rf /tmp/google.deb

USER jenkins

ENTRYPOINT ["jenkins-slave"]
