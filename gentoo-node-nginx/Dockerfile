# docker-version 0.4.8

from 42/gentoo-base

env install emerge

add ./nginx-modules-http-make.conf /tmp/
run cat /tmp/nginx-modules-http-make.conf >> /var/portage/

run $install nodejs
run $install mongodb; echo $#;
