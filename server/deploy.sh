#!/bin/bash

export CERTPATH=/etc/letsencrypt/live/appcode.leontaolong.com/fullchain.pem
export KEYPATH=/etc/letsencrypt/live/appcode.leontaolong.com/privkey.pem

export DBADDR=127.0.0.1:27017
export PORT=8449
export HTTPPORT=8448
export APNSPATH=./encrypt/AuthKey_LC84854ZM7.p8

node index.js