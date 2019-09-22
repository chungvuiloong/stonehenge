#!/bin/bash

# exit when any command fails
set -e

# Print yellow info line
info () {
  printf '\n\e[1;33m%-6s\e[m\n\n' "$1"
}

info "Information on this test:"

echo "Distribution: ${TRAVIS_DIST}"
docker --version
docker-compose --version
make debug
make ping

# Start up Stonehenge
info "Start up Stonehenge"
make up

info "Ping should resolve to 127.0.0.1 now"
make ping

# Check that DNS work still
info "Check that DNS works when curling Google. Expecting HTTP/2 200"
curl -Is https://www.google.com | head -1

# Check that we can connect to local Portainer
info "CURL portainer for checking access starts"
curl -s https://portainer.docker.sh | grep Portainer
info "CURL portainer for checking access ends"

# Tear down Stonehenge
info "Tear down Stonehenge"
make down
