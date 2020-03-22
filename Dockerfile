FROM node:alpine3.11

RUN apk update \
    && apk --no-cache add ca-certificates bash curl openjdk8-jre jq \
    && update-ca-certificates

RUN rm -rf /var/cache/apk/*

RUN npm i jsonlint -g

COPY igluctl /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
