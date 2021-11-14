#!/usr/bin/env bash
# This should be run on the host computer
# Usage: ./create_image 2.1.0
DEFAULT=2.1.0
TF_VERSION=${1:-$DEFAULT}

# Launch the container for building:
echo "Launching container with tensorflow $TF_VERSION"
tensorman +$TF_VERSION run --gpu --python3 --jupyter --root --name nlp_dev ./setup_container.sh
echo "You can now exit the container"
