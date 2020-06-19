#!/usr/bin/env bash

## This should be run inside the container
pip install -U pip
pip install -r requirements.txt

# Download NLTK data
python -m nltk.downloader -d /usr/local/share/nltk_data all

echo "Done. Now save the image by going to a new terminal window and running: tensorman save nlp_dev nlp_dev"
