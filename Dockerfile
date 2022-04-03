FROM alpine:3.15

LABEL org.opencontainers.image.authors="mhajoha@gmail.com"

RUN apk add --no-cache git bash

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY cred-helper.sh /cred-helper.sh
COPY update.sh /update.sh

ENTRYPOINT /docker-entrypoint.sh
