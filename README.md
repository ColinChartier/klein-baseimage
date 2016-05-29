# Klein
Klein is an ubuntu-backed, minimalist baseimage for [Docker](https://www.docker.com/).

It uses [runit](http://smarden.org/runit/) to handle service management, and an extremely minimal init program written in under a hundred lines of bash.

## Why should I use Klein?
Docker's attitude towards containers is to "do one thing and do it well."  This philosophy is excellent for making extensible services,  however, some things can't be done with a single process in the traditional docker-esque way.

For example, if you are connecting a [Gogs](https://github.com/gogits/gogs) image behind an [Nginx](https://github.com/nginx/nginx) reverse-proxy to handle https, and start an SSH server for SSH git integration, it doesn't make sense for the three services to be launched as separate containers.  They are intrinsically linked into a single logical unit.

That being said, it is a mistake to use Klein to launch completely different services. An IRC server and a website should be on two different Docker images, even though they may share a few common dependencies.  Doing so simply adds brittleness to your deployment, and is not the recommended use of this image.

## How should I use Klein?
Klein has two simple mechanisms that sub-dockerfiles can use, initialization scripts, and runit services.

### Initialization scripts
Any script in the /etc/init/ directory which is executable for root will automatically be started when the container itself is started with "docker start."

### Services
Services in the /etc/service/ directory are defined by [runit](http://smarden.org/runit/faq.html#create)

For example, the following creates a simple service which repeatedly logs to a file:
```
mkdir /etc/service/sillylogger/
cat << EOF > /etc/service/sillylogger/run
#! /bin/bash
while :
do
    echo "$(date) Silly!" >>/var/log/sillylog.txt
    sleep 1
done
EOF
```

Another small example, the following does the same, except for as a specific "silly" user:
```
adduser --gecos "Silly logger" --disabled-login sillylogger
mkdir /etc/service/usersillylogger/
cat << EOF > /etc/service/usersillylogger/run
#! /bin/bash
while :
do
    chpst -u sillylogger echo "$(date) Silly!" >>/var/log/sillylog.txt
    sleep 1
done
EOF
```
Notice that the services are started as infinite loops.  Runit services should not be allowed to fork, as the health of a service is determined by whether or not it is currently running.

### Caveats
This image doesn't actually use runit for anything except for service management (specifically runsvdir).

The information on the runit site about things other than services doesn't pertain to this image.  Only the documentation about services does.

This image also doesn't have mechanisms for running services whose files are written for init systems than runit.

Those written for systemd, for example, will need to be ported by hand.


## Credits
 - [Docker](https://www.docker.com/)
 - [Phusion Baseimage](https://github.com/phusion/baseimage-docker)
 - [Phusion on the PID 1 problem](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)
 - [Ubuntu](http://www.ubuntu.com/)
