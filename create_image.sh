#!/usr/bin/env bash
# Script to create a docker image
# This should be run on the host computer
#
# Usage: ./create_image <version-number>
#
##########################################
JUPYTER=false
GPU=false

usage() {
    echo "Usage: ${0} --tag $TF_VERSION --jupyter --gpu"
}

build() {
    # Launch the container for building:
    echo "Launching container with tensorflow $TF_VERSION"
    tensorman pull $TF_VERSION-gpu-jupyter
    tensorman +$TF_VERSION run --gpu --jupyter --root --name nlp_dev ./setup_container.sh
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
        ;;
    -g | --gpu)
        GPU=true
        ;;
    -v | --version) # tensorflow version
        shift
        TAG=$1
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

if [[ "$TAG" == "" ]]; then
    echo "You must provide a version for tensorflow";
    exit 1;
fi

if [[ $GPU == true ]]; then
    TAG=${TAG}-gpu
fi

if [[ $JUPYTER == true ]]; then
    TAG=${TAG}-jupyter
fi

echo $TAG