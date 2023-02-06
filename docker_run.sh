#!/usr/bin/env bash

# This script runs a Docker container.
#
# It takes a Dockerfile or its extension on the 1st argument.
# And optionally it takes a image name as 2nd argument and a 
# container name on the 3nd argument if you want to override 
# the script choice.
#
# If the extension is provided the script will search for a Dockerfile 
# with that extension. It assumes that the extension will be after a dot
# like Dockerfile.<extension>.
#
# We suggest using a descriptive extension like:
#   <system>-<project>-<deploy_environment>.
#
# Usage: ./docker_build.sh <Dockerfile|extension> [image_name]
#        ./docker_build.sh Dockerfile.alpine-hook-run
#        ./docker_build.sh alpine-hook-run
#        ./docker_build.sh alpine-hook-run test-alpine

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
IMAGE_NAME="$2"
CONTAINER_NAME="$3"

DOCKER_FILE="$ARGUMENT"

if [[ "$ARGUMENT" != Dockerfile* ]]; then
    DOCKER_FILE="Dockerfile.$ARGUMENT"
    echo "INFO: Using the 1st argument as Dockerfile extension: '$DOCKER_FILE'."
fi

EXTENSION="${DOCKER_FILE#Dockerfile.}"

if [[ ! -f "./$DOCKER_FILE" ]]; then
    echo "
ERROR: This script must be run from the directory where the 
    Dockerfile '$DOCKER_FILE' exists.
    If you know the IMAGE_NAME and the /PATH_TO_HOOK_SRC values you can 
    run the container with:

        docker run --volume /PATH_TO_HOOK_SRC:/hook-development:rw --tty \
            --interactive IMAGE_NAME bash

    Or:

        docker run --tty --interactive IMAGE_NAME bash
"
    exit 1
fi


if [ -z "$IMAGE_NAME" ]; then
    IMAGE_NAME="$EXTENSION"
    echo "
INFO: Using '$IMAGE_NAME' as the Docker image name.
    You can specify a different name at (in order of priority):
    - the 2nd argument of this script '$0';
    - the IMAGE_NAME enviroment variables;
    - the .env file as the variable mentioned above."
fi

if [ -z "$CONTAINER_NAME" ]; then
    CONTAINER_NAME="$IMAGE_NAME"
        echo \
            "INFO: Using '$CONTAINER_NAME' as the Docker container name.
    You can specify a different name at (in order of priority):
    - the 3nd argument of this script '$0';
    - the CONTAINER_NAME environment variable;
    - the .env file with a CONTAINER_NAME variable."
fi

if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
    echo "ERROR: The docker image '$IMAGE_NAME' does not exist.
    Please run 'docker pull $IMAGE_NAME' or './docker_build.sh $DOCKER_FILE' first."
    exit 1
fi

# if a docker container with the name CONTAINER_NAME already exists warn the user
if docker container inspect "$CONTAINER_NAME" &>/dev/null; then
    DOCKER_RM_OUTPUT="$(docker rm --force "$CONTAINER_NAME")"
    echo "WARNING: Removing the existing docker container '$DOCKER_RM_OUTPUT'"
fi

WORKSPACE_DIR="$(pwd)/hook-development"
chmod 775 "$WORKSPACE_DIR"
docker run --name "$CONTAINER_NAME" --volume "$WORKSPACE_DIR":/hook-development:rw --tty --interactive "$IMAGE_NAME" bash