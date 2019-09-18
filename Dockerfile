FROM alpine:latest
LABEL author="Caravela Hacker Club"

RUN apk add --no-cache \
    git \
    nodejs \
    npm \
    && npm install -g --unsafe-perm \
    elm \
    elm-analyse
