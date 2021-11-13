#!/usr/bin/env bash
## This should be run inside the container

# Install node for jupyterlab_vim
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt-get update -y && apt-get install -y nodejs
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update -y && apt-get install -y yarn

# Get CUDA version
version_string=$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2-)
echo $version_string
major=$(cut -d'.' -f1 <<< $version_string)
minor=$(cut -d'.' -f2 <<< $version_string)
cuda_version="${major}${minor}"
echo "${major}${minor}"

# Update pip3
echo "Updating pip3..."
pip3 install --upgrade pip
echo "Update complete."

# Install required packages
echo "Installing requirements..."
pip3 install -r requirements.txt -f https://download.pytorch.org/whl/cu101/torch_stable.html
echo "Installation complete."

echo "Installing spacy..."
pip3 install "spacy[cuda$cuda_version]"

echo "Downloading spacy data..."
python -m spacy download en_core_web_lg
echo "Download complete."

echo "Done. To save the image, keep this shell up, then on your host computer launch a new terminal window and run: tensorman save nlp_dev nlp_dev"

exec $SHELL
