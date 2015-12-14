FROM oneforone/backend-base:latest
MAINTAINER 1For1
LABEL version "1.0.0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y apt-transport-https \
    && echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

#RUN apt-get update
#RUN apt-get install -y ca-certificates
#RUN apt-get install -y curl
# RUN apt-get install -y lxc
RUN apt-get install -y openssh-server
#RUN apt-get install -y openjdk-7-jre-headless
RUN apt-get install -y openjdk-7-jdk
# RUN apt-get install -y lxc-docker

RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
    && adduser --disabled-password --gecos '' jenkins \
    && mkdir /var/run/sshd

RUN echo -e "jenkins\njenkins" | passwd jenkins


# Make sure that the "jenkins" user from evarga's image is part of the "docker"
# group. Needed to access the docker daemon's unix socket.
RUN usermod -a -G docker jenkins

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      git \
                                      libleptonica-dev \
                                      libtool

RUN rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/*

# Expose SSH port
EXPOSE 22

VOLUME /var/lib/docker

# place the jenkins slave startup script into the container
ADD wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker
ADD jenkins-slave-startup.sh /
CMD ["/jenkins-slave-startup.sh"]
