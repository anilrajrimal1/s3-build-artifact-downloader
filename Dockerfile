FROM alpine:latest

RUN apk update && apk add --no-cache \
    aws-cli \
    unzip \
    bash \
    && adduser -D -u 1000 appuser

WORKDIR /code

COPY entrypoint.sh /code/entrypoint.sh

RUN chmod +x /code/entrypoint.sh

USER appuser

ENTRYPOINT ["/code/entrypoint.sh"]
