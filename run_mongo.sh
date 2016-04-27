#!/bin/sh
exec /sbin/setuser mongodb /usr/bin/mongod --config /etc/mongodb.conf
