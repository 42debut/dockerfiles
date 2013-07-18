# Dockerfiles


### Oneliners

View all containers
> ```
docker -ps a
```

Delete all containers
> ```
for d in `docker ps -a | grep -v ID | awk '{ print $1 }'`; do echo $d; docker rm $d; done
```

Delete all `<none>` images
> ```
for imgId in `docker images | grep "<none>" | awk '{ print $3 }'`; do echo $imgId; docker rmi $imgId; done
```


### Troubleshooting

#### Can't internet in container

1. Make sure your **host** can reach the internet, and that DNS works:
> `ping -c 1 bacon.io`

2. Rebuild your **host** internets:
> ```
  pkill docker
  iptables -t nat -F
  ifconfig docker0 down
  brctl delbr docker0
  docker -d
  ```


### Linode Ubuntu 13.04 + Docker

  Follow the instructions here:
  https://www.linode.com/wiki/index.php/PV-GRUB#Ubuntu_12.04_Precise

  Basically:

    apt-get update
    apt-get install -y linux-virtual grub-legacy-ec2

  when prompted, select yes

    sed 's/defoptions=console=hvc0/defoptions=console=hvc0 rootflags=nobarrier/g' -i /boot/grub/menu.lst
    update-grub-legacy-ec2

  then configure Linode profile stuff and reboot.

----

  After that:
  http://docs.docker.io/en/latest/installation/ubuntulinux/#ubuntu-raring

    apt-get install lxc wget bsdtar linux-image-extra-virtual

  `apt-get update` will now be broken for some reason, but you can change the mirrors:

    MIRROR=http://mirror.csclub.uwaterloo.ca/ubuntu/
    sed 's#http://us.archive.ubuntu.com/ubuntu/#$MIRROR#g' -i /etc/apt/sources.list
    sed 's#http://security.ubuntu.com/ubuntu#$MIRROR#g' -i /etc/apt/sources.list

  Now we just need to install docker:

    add-apt-repository ppa:dotcloud/lxc-docker
    apt-get update
    apt-get install lxc-docker
