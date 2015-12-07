FROM ubuntu:latest
MAINTAINER 1For1
LABEL version="1.0.0"

RUN adduser --disabled-password --gecos '' ocr

# Base
RUN apt-get update
RUN apt-get install -y autoconf \
                          build-essential \
                          git \
                          liblept4 \
                          libleptonica-dev \
                          libgomp1 \
                          libtool

# Install python 3
RUN apt-get install -y python3 python

# Install Tesseract
RUN apt-get install -y tesseract-ocr tesseract-ocr-eng

# Install pypdfocr
RUN apt-get install -y libjpeg-dev zlib1g-dev
RUN apt-get install -y python3-pip python3-dev imagemagick poppler-utils

# Install requirements
RUN pip3 install -r requirements.txt

# Make folder
RUN mkdir /data
RUN chown -R ocr:ocr /data

# Cleanup
RUN apt-get purge --auto-remove -y autoconf \
                                      build-essential \
                                      git \
                                      libleptonica-dev \
                                      libtool
RUN rm -rf /var/cache/apk/*