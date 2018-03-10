#!/bin/bash

# intall mongodb
brew update
brew install mongodb --devel

# make db dir and spin up mongodb
rm -r ~/data
mkdir ~/data
mongod --dbpath ~/data

# OR: start up mongodb using docker
mkdir ~/data
sudo docker run -d -p 27017:27017 -v ~/data:/data/db mongo

# check who's listening on a given port
lsof -n -i:8888 | grep LISTEN