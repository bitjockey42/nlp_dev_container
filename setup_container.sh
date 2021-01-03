#!/usr/bin/env bash
## This should be run inside the container

version_string=$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2-)
echo $version_string
major=$(cut -d'.' -f1 <<< $version_string)
minor=$(cut -d'.' -f2 <<< $version_string)
cuda_version="${major}${minor}"

echo "${major}${minor}"

echo "Updating pip..."
pip install -U pip
echo "Update complete."

echo "Installing requirements..."
pip install -r requirements.txt
echo "Installation complete."

echo "Installing spacy..."
pip install "spacy[cuda$cuda_version]"

echo "Downloading spacy data..."
python -m spacy download en_core_web_lg
echo "Download complete."

echo "Done. To save the image, keep this shell up, then on your host computer launch a new terminal window and run: tensorman save nlp_dev nlp_dev"

exec $SHELL
