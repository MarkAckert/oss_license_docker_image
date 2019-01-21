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

CMD ["/usr/sbin/sshd", "-D"]