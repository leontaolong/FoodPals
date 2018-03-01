#!/bin/bash

rm -r ./db
mkdir db
mongod --dbpath ./db