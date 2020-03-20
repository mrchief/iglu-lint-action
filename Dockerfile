FROM node:lts-alpine3.9

ENV REVIEWDOG_VERSION=v0.9.17

RUN apk --no-cache --update add bash git &&
    rm -rf /var/cache/apk/*

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN npm install -g ajv-cli

COPY iglu_meta_schema.json /iglu_meta_schema.json
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
