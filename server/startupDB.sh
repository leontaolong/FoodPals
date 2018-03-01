#!/bin/bash

# intall mongodb
brew update
brew install mongodb --devel

# make db dir and spin up mongodb
rm -r ./db
mkdir db
mongod --dbpath ./db