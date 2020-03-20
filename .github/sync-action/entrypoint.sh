#!/bin/sh

set -eu

# Start the SSH agent and load key
eval "$(ssh-agent -s)"
echo "$PRIVATE_KEY" | ssh-add

# Publish
site $GITHUB_WORKSPACE/Output --sync-to=pete@peteschaffner.com:www --exit-on-sync