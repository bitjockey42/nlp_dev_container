`nlp_dev`
==============================

Tools and notebooks for NLP

Setup
-------------------

### pop os requirements

Documentation:

- [Tensorman](https://support.system76.com/articles/use-tensorman/)

Install dependencies:

```
sudo apt install tensorman
sudo apt install nvidia-container-runtime
```

**For Pop!_OS 21.10 and later:**
```
sudo apt install nvidia-docker2
```

**For Pop!_OS 20.04:**
```
sudo apt install nvidia-container-runtime
```

**Install driver**
```
sudo apt install nvidia-driver-510
```

Then add yourself to the docker group:

```
sudo usermod -aG docker $USER
```

Then reboot.

## Usage

### Host Usage

```
    Usage: ./setup.sh [-t VERSION] [--jupyter] [--gpu] [--python3] [-n CONTAINER_NAME]

    Options:
        -t, --tensorflow-version:
        -j, --jupyter: Use jupyter lab
        -g, --gpu: Use gpu
        -py3, --python3: Force python3 ()
        -n, --name:  Name to use for the container
        --skip-setup: Don't run setup script
        -h, --help
```

### Container Usage

```
    Usage: ./setup.sh [--pytorch] [--spacy]
   
    Options:
        -p, --pytorch: Install pytorch
        -s, --spacy:  Install spacy
        -h, --help


```

### Starting the container (Host)

On the host machine, start a container with root privileges (needed for installing packages), GPU access, Python 3, and Jupyter lab:

```bash
./setup.sh -j -g -n nlp_dev

# you can also specify a tensorflow version
./setup.sh -t 2.1.0 -j -g -py3 -n nlp_dev
```

### Setup container

Then, inside the container, install base requirements and optionally `pytorch`, `spacy`.

```bash
# Only install basic requirements
./setup.sh

# Install pytorch and spacy
./setup.sh -p -s
```

Once that's completed, do this in a new terminal window:

```bash
tensorman save nlp_dev nlp_dev
```

That should now be available as an image.

Usage
------------------------------

### Running the container

Copy the `Tensorman.toml.example` to the root of your project directory, `PROJECT_DIR`.

```
cp Tensorman.toml.example $PROJECT_DIR/Tensorman.toml
```

Once setup is complete, you can just use `tensorman run` to run a command inside the new `nlp_dev` container.

To start jupyter lab inside the container:

```bash
tensorman run ./start_jupyterlab.sh
```

### Running the container manually

Using `tensorman` and the pre-built `nlp_dev` image:

```sh
# If there is no Tensorman.toml
tensorman "=nlp_dev" run -p 8888:8888 --gpu bash

# If there is a Tensorman.toml
tensorman run bash
```

Running `jupyterlab` inside the tensorman container:

```sh
jupyter lab --ip=0.0.0.0 --no-browser
```

Then go to the link printed out by `jupyter`, e.g. `http://127.0.0.1:8888/?token=<jupyter token here>`

