FROM alpine:latest

RUN apk add --no-cache unzip aws-cli

WORKDIR /code

COPY entrypoint.sh /code/entrypoint.sh
RUN chmod +x /code/entrypoint.sh

USER root

ENTRYPOINT ["/code/entrypoint.sh"]