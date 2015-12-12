FROM oneforone/backend-base:latest
MAINTAINER 1For1
LABEL version "1.0.0"

# Add in Jenkins User
RUN adduser --disabled-password --gecos '' ocr
RUN echo -e "jenkins\njenkins" | passwd jenkins

RUN apt-get install -y openssh-server openjdk-6-jdk jenkins

RUN mkdir /var/run/sshd

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      git \
                                      libleptonica-dev \
                                      libtool

RUN rm -rf /var/cache/apk/*