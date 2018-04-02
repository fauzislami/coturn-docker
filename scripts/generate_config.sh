#!/bin/sh
# generates a config file for a coturn server; hopefully secure enough

SERVER_NAME=${1}
DATA_DIR=${2}
KEY_NAME=${3}
CERT_NAME=${4}
CONFIG_FILE=${5}

secret=$(pwgen -s 64 1)

# create the self-signed certificate
openssl req -newkey rsa:4096 -new -nodes -x509 -days 3650 -keyout $DATA_DIR/$KEY_NAME -out $DATA_DIR/$CERT_NAME -subj "/C=FR/ST=BarbedLand/O=BarbedGroup/CN=$SERVER_NAME"

# create the config file
touch $DATA_DIR/$CONFIG_FILE

# fill in the config file
echo "lt-cred-mech" > "$DATA_DIR/$CONFIG_FILE"
echo "use-auth-secret" >> "$DATA_DIR/$CONFIG_FILE"
echo "static-auth-secret=${secret}" >> "$DATA_DIR/$CONFIG_FILE"
echo "realm=turn.${SERVER_NAME}" >> "$DATA_DIR/$CONFIG_FILE"
echo "cert=$DATA_DIR/$CERT_NAME" >> "$DATA_DIR/$CONFIG_FILE"
echo "pkey=$DATA_DIR/$KEY_NAME" >> "$DATA_DIR/$CONFIG_FILE"
echo "cipher-list=\"HIGH\"" >> "$DATA_DIR/$CONFIG_FILE"
