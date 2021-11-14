#!/usr/bin/env bash
## This should be run inside the container
INSTALL_PYTORCH=false
INSTALL_SPACY=false
INSTALL_JUPYTERLAB_VIM=false

usage() {
    cat <<USAGE

    Usage: $0 [--pytorch] [--jupyterlab-vim] [--spacy]

    Options:
        -p, --pytorch: Install pytorch
        -j, --jupyterlab-vim: Install jupyterlab vim extension
        -s, --spacy:  Install spacy

USAGE
    exit 1
}

install_node() {
    # Install node for jupyterlab_vim
    curl -sL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get update -y && apt-get install -y nodejs
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
    apt-get update -y && apt-get install -y yarn
}

install_jupyterlab_vim() {
    install_node
    pip3 install -U jupyterlab_vim
}

upgrade_pip() {
    # Update pip3
    echo "Updating pip3..."
    pip3 install --upgrade pip
    echo "Update complete."
}

get_cuda_version() {
    # Get CUDA version
    version_string=$(nvcc --version | grep "release" | awk '{print $6}' | cut -c2-)
    echo $version_string
    major=$(cut -d'.' -f1 <<< $version_string)
    minor=$(cut -d'.' -f2 <<< $version_string)
    cuda_version="${major}${minor}"
    echo "${major}${minor}"
}

install_requirements() {
    echo "Installing requirements..."
    pip3 install -r requirements.txt
    echo "Installation complete."
}

install_pytorch() {
    get_cuda_version

    echo "Installing requirements..."
    pip3 install -r requirements/requirements-pytorch.txt -f "https://download.pytorch.org/whl/cu$cuda_version/torch_stable.html"
    echo "Installation complete."
}

install_spacy() {
    get_cuda_version

    echo "Installing spacy..."
    pip3 install "spacy[cuda$cuda_version]"

    echo "Downloading spacy data..."
    python -m spacy download en_core_web_lg
    echo "Download complete."
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

while [ "$1" != "" ]; do
    case $1 in
    -p | --pytorch)
        INSTALL_PYTORCH=true
        ;;
    -s | --spacy)
        INSTALL_SPACY=true
        ;;
    -j | --jupyterlab-vim)
        INSTALL_JUPYTERLAB_VIM=true
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

upgrade_pip
install_requirements

if [[ $INSTALL_JUPYTERLAB_VIM == true ]]; then
    install_jupyterlab_vim
fi

if [[ $INSTALL_SPACY == true ]]; then
    install_spacy
fi

if [[ $INSTALL_PYTORCH == true ]]; then
    install_pytorch
fi

echo "Done. To save the image, keep this shell up, then on your host computer launch a new terminal window and run: tensorman save nlp_dev nlp_dev"

exec $SHELL
