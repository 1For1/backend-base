FROM oneforone/backend-base:latest
MAINTAINER 1For1
LABEL version "1.0.0"

# TODO Copy code from here
#FROM evarga/jenkins-slave

VOLUME /var/lib/docker

# Expose SSH port
EXPOSE 22

RUN echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl lxc iptables \
    && apt-get install -y openssh-server openjdk-7-jdk jenkins \
    && apt-get install -y lxc-docker \
    && apt-get install -y openssh-server

RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
    && adduser --quiet jenkins \
    && mkdir /var/run/sshd

RUN echo -e "jenkins\njenkins" | passwd jenkins


# Make sure that the "jenkins" user from evarga's image is part of the "docker"
# group. Needed to access the docker daemon's unix socket.
RUN usermod -a -G docker jenkins

# place the jenkins slave startup script into the container
ADD wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

ADD jenkins-slave-startup.sh /
CMD ["/jenkins-slave-startup.sh"]

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      git \
                                      libleptonica-dev \
                                      libtool

RUN rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/*