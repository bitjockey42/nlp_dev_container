`nlp_dev`
==============================

Tools and notebooks for NLP

Setup
-------------------

### pop os requirements

Documentation:

- [cuda](https://support.system76.com/articles/cuda/)
- [Tensorman](https://support.system76.com/articles/use-tensorman/)

```
sudo apt install system76-cuda-10.2
sudo apt install system76-cudnn-10.2
```

Set as default:

```
# Select cuda-10.2
sudo update-alternatives --config cuda
```

### Creating the tensorman image

```bash
./create_image.sh
```

Once that's completed, do this in a new window:

```bash
tensorman save nlp_dev nlp_dev
```

That should now be available as a 

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

