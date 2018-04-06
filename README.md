# coturn-docker
A docker image for a coturn TURN server. See [coturn/coturn](https://github.com/coturn/coturn).

This is the VoIP backend server for a synapse Matrix server. It's optional if you don't plan on enabling VoIP.

The image exposes port `3478`. By design, the TURN server will only bind to `127.0.0.1` (the Dockerfile must be altered for this to change).

## Building the image

**Arguments:**

It is generally OK to leave the defaults where they exist.

* **COTURN_VERSION** (string): a coturn server release name as found at [coturn/coturn/releases](https://github.com/coturn/coturn/releases). *Default: `4.5.0.7`*

* **COTURN_USER** (string): the name of the system user that will run the coturn server process. This user will be created within the docker container. *Default: `matrix-coturn`*

* **COTURN_GROUP** (string): the name of the user group running the coturn server process. Similarly it will be created within the docker container. *Default: `matrix-coturn`*

* **SERVER_NAME** (string): hostname of the machine which will serve the coturn server. There is no default, hence you must provide a value here. The hostname must be resolvable over the intended network by all potential clients.

 *Note that a self-signed certificate (10 years validity) with CN=$SERVER_NAME will be created automatically. You should consider replacing with a real one, e.g. Let's Encrypt.*

* **KEY_NAME** (string): name of the private key file that will be auto-generated upon building the docker image. *Default: `matrix-coturn-key.pem`*

* **CERT_NAME** (string): name of the public X.509 certificate file that will be auto-generated upon building the docker image. *Default: `matrix-coturn-cert.pem`*

**Note:** during the build, the script will output something like `The automatically generated secret is: <64 char long secret>`. This is the automatically generated coturn secret to paste into the synapse server's configuration file if using the coturn server for VoIP support.

**Example build command:**

This will create an image named `image_name` for a server url `synapse_server_url` and it will be tagged `latest`.

    docker build --build-arg SERVER_NAME=<coturn_server_hostname> -t <image_name> .

## Running

**Exposed volumes:**

* /data (certificates mainly, other stuff maybe)

**Exposed ports:**

* 3478/TCP

**Example run command:**

    docker run -d -v coturn-data:/data -p 3478:3478 <image_name>
