#!/usr/bin/env bash
JUPYTER=false
GPU=false
TF_VERSION=2.6.1
NAME=nlp_dev
SETUP=true
INSTALL_PYTORCH=false
INSTALL_SPACY=false
INSTALL_JUPYTERLAB_VIM=false

# The last version that requires the --python3 is 2.2.3
opts=("root")
command=( $0 )

host_usage() {
    cat <<USAGE

    Usage: $0 [-t VERSION] [--jupyter] [--gpu] [--python3] [-n CONTAINER_NAME]

    Options:
        -t, --tensorflow-version:
        -j, --jupyter: Use jupyter lab
        -g, --gpu: Use gpu
        -py3, --python3: Force python3 ()
        -n, --name:  Name to use for the container
        --skip-setup: Don't run setup script
        -h, --help

USAGE
    exit 1
}

container_usage() {
    cat <<USAGE

    Usage: $0 [--pytorch] [--spacy]
   
    Options:
        -p, --pytorch: Install pytorch
        -s, --spacy:  Install spacy
        -h, --help

USAGE
    exit 1
}

usage() {
    if [ -f /.dockerenv ]; then
        container_usage
    else
        host_usage
    fi
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
    pip install -U jupyterlab_vim
}

upgrade_pip() {
    # Update pip
    echo "Updating pip..."
    pip install --upgrade pip
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
    pip install -r requirements.txt
    echo "Installation complete."
}

install_pytorch() {
    get_cuda_version

    echo "Installing requirements..."
    pip install -r requirements/requirements-pytorch.txt -f "https://download.pytorch.org/whl/cu$cuda_version/torch_stable.html"

    # Check if installed or not
    success=$(python -c "import torch; print(torch.cuda.is_available())")

    if [[ $success != "True" ]]; then
        echo "pytorch did not install successfully"
        exit 1
    fi

    echo "Installation complete."
}

install_spacy() {
    get_cuda_version

    echo "Installing spacy..."
    pip install "spacy[cuda$cuda_version]"

    echo "Downloading spacy data..."
    python -m spacy download en_core_web_lg
    echo "Download complete."
}

setup_container() {
    upgrade_pip
    install_requirements
    install_jupyterlab_vim

    if [[ $INSTALL_SPACY == true ]]; then
        install_spacy
    fi

    if [[ $INSTALL_PYTORCH == true ]]; then
        install_pytorch
    fi

    verify_tensorflow
}

verify_tensorflow() {
    success=$(python -c "import tensorflow as tf; print(tf.test.is_gpu_available())")

    if [[ $success != "True" ]]; then
        echo "GPU unavailable to tensorflow"
        exit 1
    fi
}

setup_image() {
    echo "Building container"
    TAG=$TF_VERSION

    if [[ $GPU == true ]]; then
        TAG=${TAG}-gpu
    fi

    if [[ $JUPYTER == true ]]; then
        TAG=${TAG}-jupyter
    fi

    # Build args
    for opt in "${opts[@]}"; do
        tensorman_flags+=( --$opt )
    done

    if [[ $SETUP == false ]]; then
        echo "Skip setup"
        command=("bash")
    fi

    build
}

build() {
    # Launch the container for building:
    echo "Launching container with tensorflow $TF_VERSION"
    tensorman pull $TAG
    tensorman +$TF_VERSION run ${tensorman_flags[@]} --name $NAME ${command[@]}
    echo "You can now exit the container"
}

if [ $# -eq 0 ]; then
    if [ -f /.dockerenv ]; then
        setup_container
        exec $SHELL
    fi
    usage
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
    -py3 | --python3 )
        opts+=("python3")
        ;;
    -p | --pytorch)
        INSTALL_PYTORCH=true
        ;;
    -s | --spacy)
        INSTALL_SPACY=true
        ;;
    --skip-setup)
        SETUP=false
        ;;
    -t | --tensorflow-version) # tensorflow version
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

# Determine if inside the container or not
if [ -f /.dockerenv ]; then
    setup_container
else 
    setup_image
fi
