`nlp_dev`
==============================

Tools and notebooks for NLP

Setup
---------

### Creating the tensorman image

```bash
./create_image.sh
```

Once that's completed, do this in a new window:

```bash
tensorman save nlp_dev nlp_dev
```

### Running the container

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

