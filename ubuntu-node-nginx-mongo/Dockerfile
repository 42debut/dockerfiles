# docker-version  0.4.8
from 42/ubuntu-node-nginx

# install mongodb
run apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
run echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
run $update
run $install mongodb-10gen; echo $#;
run mkdir -p /data/db
