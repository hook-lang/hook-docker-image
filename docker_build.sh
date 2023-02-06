#!/usr/bin/env bash

# This script builds a Docker image.
#
# It takes a multi stage Dockerfile or its extension on the 1st argument
# and the target stage as the 2nd argument. Optionally it can take a 
# image name as 3nd argument if you want to override the script name choice.
#
# If the extension is provided the script will search for a Dockerfile 
# with that extension. It assumes that the extension will be after a dot
# like Dockerfile.<extension>.
#
# We suggest using a descriptive extension like:
#   <system>-<project>
#   alpine-hook
#
# The stage refers to the build type like:
#   development
#   run
#
# The extension and stage are used to tag the image and run it like:
#   <system>-<project>-<stage>
#   alpine-hook-development
#   alpine-hook-run
#
# Usage: ./docker_build.sh <Dockerfile|extension> [image_name]
#        ./docker_build.sh Dockerfile.alpine-hook run
#        ./docker_build.sh alpine-hook run
#        ./docker_build.sh alpine-hook development test-bug-fix
#
if ! docker info &>/dev/null; then
    echo "ERROR: You must have the Docker installed and permission to run it."
    exit 1
fi

if [ ! -f ".env" ]; then
    echo "INFO: The .env file does not exist."
else
    echo "INFO: Loading the .env file."
    source .env
fi

ARGUMENT="$1"
STAGE="$2"
IMAGE_NAME="$3"

DOCKER_FILE="$ARGUMENT"

if [[ "$ARGUMENT" != Dockerfile* ]]; then
    DOCKER_FILE="Dockerfile.$ARGUMENT"
    echo "INFO: Using the 1st argument as Dockerfile extension: '$DOCKER_FILE'."
fi

if [[ ! -f "./$DOCKER_FILE" ]]; then
    echo "ERROR: This script must be run from the directory where the Dockerfile '$DOCKER_FILE' exists."
    exit 1
fi

EXTENSION="${DOCKER_FILE#Dockerfile.}"

if [ -z "$IMAGE_NAME" ]; then
    IMAGE_NAME="$EXTENSION-$STAGE"
    echo \
        "INFO: Using '$IMAGE_NAME' as the Docker image name.
    You can specify a different name at (in order of priority):
    - the 2nd argument of this script '$0 <Dockerfile|extension> [image_name]';
    - the IMAGE_NAME enviroment variable;
    - the .env file with a IMAGE_NAME variable."
fi

docker build --target "$STAGE" --tag "$IMAGE_NAME" --file "$DOCKER_FILE" .