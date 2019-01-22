FROM ahumanfromca/jenkins-npm-agent

USER root

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get -y install ruby2.5 ruby2.5-dev
RUN gem install license_finder
RUN apt-get install -y python-dev python-pip bzip2 xz-utils zlib1g libxml2-dev libxslt1-dev


RUN mkdir -p /opt/scancode
WORKDIR /opt/scancode
RUN curl -L -X GET https://github.com/nexB/scancode-toolkit/releases/download/v2.9.2/scancode-toolkit-2.9.2.tar.bz2 --output scancode-toolkit-2.9.2.tar.bz2 --silent
RUN tar xvjf scancode-toolkit-2.9.2.tar.bz2
RUN ln -s /opt/scancode/scancode-toolkit-2.9.2/scancode /usr/local/bin/scancode


# JNLP Agent Configuration (Copied from Jenkins JNLP Container Dockerfiles)
ARG VERSION=3.28

RUN curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

USER jenkins
RUN mkdir /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
VOLUME /home/jenkins
WORKDIR /home/jenkins

USER root
COPY jenkins-agent-entrypoint /usr/local/bin/jenkins-agent-entrypoint

ENTRYPOINT [ "jenkins-agent-entrypoint" ]