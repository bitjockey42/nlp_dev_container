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

echo "Done. To save the image, keep this shell up, then on your host computer launch a new termina window and run: tensorman save nlp_dev nlp_dev"

exec $SHELL
