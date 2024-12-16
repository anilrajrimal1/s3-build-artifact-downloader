FROM alpine:latest

RUN apk update && apk add --no-cache bash zip aws-cli

WORKDIR /home/anil

COPY entrypoint.sh /home/anil/entrypoint.sh

RUN chmod +x /home/anil/entrypoint.sh

CMD ["bash", "/home/anil/entrypoint.sh"]
