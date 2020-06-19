#!/usr/bin/env bash
## This should be run inside the container

echo "Updating pip..."
pip install -U pip
echo "Update complete."

echo "Installing requirements..."
pip install -r requirements.txt
echo "Installation complete."

# Download NLTK data
echo "Downloading NLTK data..."
python -m nltk.downloader -d /usr/local/share/nltk_data all
echo "Download complete."

echo "Done. Now save the image by going to a new terminal window in your host and running: tensorman save nlp_dev nlp_dev"
