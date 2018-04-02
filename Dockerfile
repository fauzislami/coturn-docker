FROM alpine:3.7

# coturn dependencies
ENV REAL_DEPS="sqlite libevent openssl"
ENV BUILD_DEPS="git shadow pwgen g++ make sqlite-dev libevent-dev openssl-dev linux-headers"
RUN apk update && apk add $REAL_DEPS $BUILD_DEPS

# get the latest (as yet) release
ARG COTURN_VERSION=4.5.0.7
RUN git clone --branch $COTURN_VERSION https://github.com/coturn/coturn.git coturn

# build coturn
WORKDIR /coturn
RUN ./configure && make && make install
WORKDIR /

# user and folders configuration
RUN mkdir /build
COPY scripts/ensure_user_and_group.sh /build/ensure_user_and_group.sh

ARG COTURN_USER=matrix-coturn
ARG COTURN_GROUP=matrix-coturn
RUN /build/ensure_user_and_group.sh $COTURN_USER $COTURN_GROUP

ENV DATA_DIR="/data"
RUN mkdir $DATA_DIR && chmod o+r $DATA_DIR

# create config
COPY scripts/generate_config.sh /build/generate_config.sh
ARG SERVER_NAME
ARG KEY_NAME=matrix-coturn-key.pem
ARG CERT_NAME=matrix-coturn-cert.pem
ENV CONFIG_FILE=coturn.conf
RUN /build/generate_config.sh $SERVER_NAME $DATA_DIR $KEY_NAME $CERT_NAME $CONFIG_FILE

USER $COTURN_USER:$COTURN_GROUP

ENTRYPOINT turnserver -a -L 127.0.0.1 -E 127.0.0.1 -c $DATA_DIR/$CONFIG_FILE
EXPOSE 3478
VOLUME ["$DATA_DIR"]
