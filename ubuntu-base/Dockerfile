# docker-version  0.4.8
from ubuntu:12.10

# dry-ing up some commands
env update  apt-get update
env install apt-get install -y

run $update

run $install git
run $install build-essential
run $install python python-software-properties
run $install software-properties-common
run $install nano vim