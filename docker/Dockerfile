##############################
#      UX Aspects Build      #
##############################

# Set the base image for this installation
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Gita Narasimhan (gita.narasimhan@hpe.com)

ENV NODE_VERSION 7.9.0
ENV NODE_DIR /opt/nodejs

# Install Initial Prerequisites
RUN apt-get update && \
    apt-get install -y sudo \
    git \
    wget \
    curl \
    bzip2

# Install NodeJS
RUN mkdir ${NODE_DIR} && \
    curl -L https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | tar xvzf - -C ${NODE_DIR} --strip-components=1

# Add Node Directory to path variables
ENV PATH $PATH:${NODE_DIR}/bin

# Install Prerequisites
RUN apt-get install -y \
    net-tools \
    psmisc \
    libfontconfig && \
    npm install -g grunt-cli && \
    npm install -g bower

RUN mkdir /.npm
RUN chmod a+rw /.npm
RUN chmod a+rw /home
