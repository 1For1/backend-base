FROM ubuntu:latest
MAINTAINER 1For1
LABEL version="1.0.0"

RUN adduser --disabled-password --gecos '' ocr

ADD requirements.txt /app/requirements.txt
WORKDIR /app/

# For Jenkins DIND
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y apt-transport-https \
    && echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9


# Base
RUN apt-get update \
    && apt-get install -y autoconf \
                          build-essential \
                          git \
                          liblept4 \
                          libleptonica-dev \
                          libgomp1 \
                          libtool \
    && apt-get install -y python3 python libxml2-dev libxslt1-dev \
    && apt-get install -y tesseract-ocr tesseract-ocr-eng \
    && apt-get install -y libjpeg-dev zlib1g-dev antiword \
    && apt-get install -y python-pip python-dev imagemagick poppler-utils \
    && pip install -r requirements.txt \
    && mkdir /data \
    && chown -R ocr:ocr /data

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      libleptonica-dev \
                                      libtool
RUN rm -rf /var/cache/apk/*