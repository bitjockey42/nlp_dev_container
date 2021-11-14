#!/usr/bin/env bash
#
# Script to create a docker image
# This should be run on the host computer
##########################################
JUPYTER=false
GPU=false
TF_VERSION=2.1.0
NAME=nlp_dev
opts=()

usage() {
    echo "Usage: ${0} --tag $TF_VERSION --jupyter --gpu"
}

build() {
    # Launch the container for building:
    echo "Launching container with tensorflow $TF_VERSION"
    tensorman pull $TAG
    tensorman +$TF_VERSION run ${tensorman_opts[@]} --root --name $NAME ./setup_container.sh
    echo "You can now exit the container"
}

# if no arguments are provided, return usage function
if [ $# -eq 0 ]; then
    usage # run usage function
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
    -v | --version) # tensorflow version
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
    tensorman_opts+=( --$opt )
done

build
