# DOCKER-VERSION 0.4.8

from tianon/gentoo

# Setup some envs, could be useful
env IMAGE_NAME 42/gentoo

# Remove useless dev nodes
run rm -rf /dev/{hd*,sd*,core,mem,port,input}

# Setup OpenRC-related stuff
## short-circuit openrc's autodetection
run sed 's/^#rc_sys=""/rc_sys="lxc"/g' -i /etc/rc.conf
## fix for error caused by openrc <0.10.2 (~may 2012)
run rm /etc/runlevels/boot/termencoding; echo "Return code: $#";
## remove netmount from default runlevel (openrc leaves it in)
run rm /etc/runlevels/default/netmount
## remove net.lo from boot runlevel (~jan 2013; openrc-0.11.8)
run rm /etc/runlevels/boot/net.lo
## fix issues with `net` dependency
run echo 'rc_provide="net"' >> /etc/rc.conf
## this fixes problems when running `rc-status`
run mkdir /tmp/init.d
run ln -s /tmp/init.d /lib64/rc/init.d


# Set timezone to UTC
run cp /usr/share/zoneinfo/UTC /etc/localtime


# Portage Setup

## Add our own make.conf file
add ./make.conf /etc/portage/make.conf

## Setup portage directories
run mkdir -p /var/portage/{tree,logs,packages,distfiles}
run ln -s /var/portage/tree /usr/portage
run mkdir /tmp/portage-tmp
run ln -s /tmp/portage-tmp /var/portage/tmp

# Setup profile
run rm /etc/portage/make.profile
run ln -s /var/portage/tree/profiles/default/linux/amd64/13.0 /etc/portage/make.profile

## Installing the latest portage tree snapshot
run emerge-webrsync

## Make sure that portage is updated
run emerge -u portage

## Fully update the system
# run emerge --update --deep --with-bdeps=y --newuse world

## Update the config files
run etc-update --automode -5

## Update the enviroment vars
run env-update