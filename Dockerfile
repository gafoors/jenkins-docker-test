FROM docker:18-dind
ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTING_VERSION 3.29
ENV DOCKER_HOST unix:///var/run/docker.sock
RUN apk --update add curl tar git openssh bash openjdk8 sudo

# Get Maven
ARG MAVEN_VERSION=3.6.1
ARG USER_HOME_DIR="/root"
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=http://apache.mirror.anlx.net/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Get Jenkins slave jar for JNLP (Java Web Start)
RUN adduser -D -h $JENKINS_HOME -s /bin/sh jenkins jenkins \
    && adduser jenkins root \
    && chmod a+rwx $JENKINS_HOME
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/local/bin/dockerd" > /etc/sudoers.d/00jenkins && chmod 440 /etc/sudoers.d/00jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: /usr/local/bin/docker" > /etc/sudoers.d/01jenkins && chmod 440 /etc/sudoers.d/01jenkins
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
    && chmod 755 /usr/share/jenkins \
    && chmod 644 /usr/share/jenkins/slave.jar

# Set Entrypoint 
COPY entrypoint.sh /usr/local/bin/entrypoint
VOLUME $JENKINS_HOME
WORKDIR $JENKINS_HOME
USER jenkins 
ENTRYPOINT ["/usr/local/bin/entrypoint"]