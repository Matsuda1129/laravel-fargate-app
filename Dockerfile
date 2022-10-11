FROM node:16-alpine as node
FROM nginx:1.20-alpine
LABEL maintainer="ucan-lab <yes@u-can.pro>"
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

ENV TZ=UTC

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++

RUN apk add --update --no-cache --repository http://nl.alpinelinux.org/alpine/edge/main libstdc++
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
# RUN apt update && apt install -y nodejs
# node command
COPY --from=node /usr/local/bin /usr/local/bin
# npm command
COPY --from=node /usr/local/lib /usr/local/lib
# yarn command
COPY --from=node /opt /opt
# nginx config file
COPY ./infra/docker/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /work/backend
