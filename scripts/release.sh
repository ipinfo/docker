#!/bin/bash

VSN=$1

# Set version to latest if no version provided.
if [ -z "$VSN" ]; then
    VSN="latest"
fi

# Build the Docker image.
docker build -t ipinfo-db:$VSN .

# Push the Docker image to a registry.
docker push ipinfo/ipinfo-db:$VSN
