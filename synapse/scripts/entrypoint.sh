#!/bin/bash
set -e

envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml

exec python3 -m synapse.app.homeserver \
  --config-path /data/homeserver.yaml

