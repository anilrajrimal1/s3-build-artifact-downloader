FROM alpine:latest

RUN apk add --no-cache unzip aws-cli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER root

ENTRYPOINT ["/entrypoint.sh"]