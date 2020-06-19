`nlp_dev`
==============================

Tools and notebooks for NLP

Setup
---------

### Creating the tensorman image

```sh
# Launch the container:
tensorman run --gpu --python3 --jupyter --root --name nlp_dev bash

# Inside the container:
pip install -U pip
pip install -r requirements.txt

# Download NLTK data
python -m nltk.downloader -d /usr/local/share/nltk_data all

# In a different terminal window on the host:
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

