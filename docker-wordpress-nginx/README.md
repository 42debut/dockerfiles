
# docker-wordpress-nginx

A Dockerfile that installs the latest wordpress, nginx, php-apc and php-fpm.


## Installation

```
$ git clone https://github.com/eugeneware/docker-wordpress-nginx.git
$ cd docker-wordpress-nginx
$ docker build -t="docker-wordpress-nginx" .
```


## Usage

To spawn a new instance of wordpress:
```
$ WORDPRESS=$(docker run -d -p <host-port>:80 docker-wordpress-nginx)
```


## Mad Props

Original work by sir [eugeneware](https://github.com/eugeneware)<br>
https://github.com/eugeneware/docker-wordpress-nginx

> NB: A big thanks to [jbfink](https://github.com/jbfink/docker-wordpress) who did most
> of the hard work on the wordpress parts!
