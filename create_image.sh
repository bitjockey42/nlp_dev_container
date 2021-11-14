#!/usr/bin/env bash
#
# Script to create a docker image
# This should be run on the host computer
##########################################
JUPYTER=false
GPU=false
TF_VERSION=2.1.0
NAME=nlp_dev
SETUP=true
opts=("root")
scripts=("./setup_container.sh")

usage() {
    cat <<USAGE

    Usage: $0 [-t TENSORFLOW_VERSION] [--jupyter] [--gpu] [-n CONTAINER_NAME]

    Options:
        -t, --tensorflow-version:
        -j, --jupyter: Use jupyter lab
        -n, --name:  Name to use for the container
        --skip-setup: Don't run setup script

USAGE
    exit 1
}

build() {
    # Launch the container for building:
    echo "Launching container with tensorflow $TF_VERSION"
    tensorman pull $TAG

    if [[ $SETUP == false ]]; then
        echo "Skip setup"
        scripts=("bash")
    fi
        
    tensorman +$TF_VERSION run ${tensorman_flags[@]} --name $NAME ${scripts[@]}
    echo "You can now exit the container"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while [ "$1" != "" ]; do
    case $1 in
    -j | --jupyter)
        JUPYTER=true
        opts+=("jupyter")
        ;;
    -g | --gpu)
        GPU=true
        opts+=("gpu")
        ;;
    --skip-setup)
        SETUP=false
        ;;
    -t | --tensorflow-version) # tensorflow version
        shift
        TF_VERSION=$1
        ;;
    -n | --name)
        shift
        NAME=$1
        ;;
    -h | --help)
        usage
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

TAG=$TF_VERSION

if [[ $GPU == true ]]; then
    TAG=${TAG}-gpu
fi

if [[ $JUPYTER == true ]]; then
    TAG=${TAG}-jupyter
fi

# Build args
for opt in "${opts[@]}"; do
    tensorman_flags+=( --$opt )
done

build
