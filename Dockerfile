FROM ubuntu:14.04

# Also :16.04, :14.04

MAINTAINER 1For1
LABEL version="1.0.0"

RUN adduser --disabled-password --gecos '' ocr

ADD requirements.txt /app/requirements.txt
WORKDIR /app/

# For Jenkins DIND
ENV DEBIAN_FRONTEND noninteractive

# REMOVED apt-get install -y apt-transport-https \
RUN apt-get update \
    && apt-get install -y apt-transport-https \
    && echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# REMOVED - liblept4 \
# Base
RUN apt-get update \
    && apt-get install -y autoconf \
                          build-essential \
                          git \
                          liblept4 \
                          libleptonica-dev \
                          libgomp1 \
                          libtool \
                          libssl-dev \
                          libffi-dev \
    && apt-get install -y python3 python libxml2-dev libxslt1-dev \
    && apt-get install -y tesseract-ocr tesseract-ocr-eng \
    && apt-get install -y libjpeg-dev zlib1g-dev antiword \
    && apt-get install -y python-pip python-dev imagemagick poppler-utils \
    && apt-get install -y libblas-dev liblapack-dev libatlas-base-dev gfortran \
    && apt-get install -y vim \
    && apt-get install -y python-software-properties software-properties-common \
    && add-apt-repository -y ppa:fkrull/deadsnakes-python2.7 \
    && apt-get update \
    && apt-get upgrade -y \
    && pip install numpy \
    && pip install -r requirements.txt \
    && mkdir /data \
    && chown -R ocr:ocr /data \
    && chmod 777 /usr/local/lib/python2.7/dist-packages/uszipcode \
    && python -m nltk.downloader -d /usr/share/nltk_data punkt \
    && python -m nltk.downloader -d /usr/share/nltk_data averaged_perceptron_tagger \
    && python -m nltk.downloader -d /usr/share/nltk_data maxent_ne_chunker \
    && python -m nltk.downloader -d /usr/share/nltk_data treebank \
    && python -m nltk.downloader -d /usr/share/nltk_data hmm_treebank_pos_tagger \
    && python -m nltk.downloader -d /usr/share/nltk_data maxent_treebank_pos_tagger \
    && python -m nltk.downloader -d /usr/share/nltk_data wordnet \
    && python -m nltk.downloader -d /usr/share/nltk_data words \
    && python -m nltk.downloader -d /usr/share/nltk_data stopwords

# ipython
RUN apt-get -y install libxft-dev libpng12-dev libzmq3-dev libsqlite3-dev sqlite3 zlib1g-dev\
    && pip install ipython[all] \
    && pip install ipywidgets matplotlib \
    && ipython profile create

# for dbus
RUN apt-get build-dep libdbus-1-dev -y
RUN apt-get install python-dbus -y

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      libleptonica-dev \
                                      libtool
RUN rm -rf /var/cache/apk/*
