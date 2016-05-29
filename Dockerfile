FROM ubuntu:16.04

MAINTAINER Colin Chartier <me@colinchartier.com>

#remove systemd and sysvinit,
#if people absolutely need those, they shouldn't be using this image.
RUN DEBIAN_FRONTEND=noninteractive apt-get --purge remove -yq --allow-remove-essential \
    systemd systemd-sysv

#we don't need timezones
RUN DEBIAN_FRONTEND=noninteractive apt-get --purge remove -yq tzdata

#install runit
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq runit && \
    rm -rf /var/lib/apt/lists/*

#setup our init and service directories, and secure them
RUN rm -rf /etc/init.d /etc/init /etc/service && \
    mkdir /etc/init/ /etc/service && \
    chmod 700 /etc/service /etc/init

#add our bootstrapper
ADD sbin/init /sbin/init

CMD ["/sbin/init"]