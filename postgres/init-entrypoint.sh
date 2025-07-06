#!/bin/sh
envsubst < /docker-entrypoint-initdb.d/init.sql.template > /docker-entrypoint-initdb.d/init.sql
exec docker-entrypoint.sh "$@"

