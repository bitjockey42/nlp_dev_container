#!/usr/bin/env bash
# This should be run on the host computer

# Launch the container:
echo "Launching container"
tensorman run --gpu --python3 --jupyter --root --name nlp_dev ./setup_container.sh
echo "You can now exit the container"
