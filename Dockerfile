FROM alpine:latest

RUN apk update && apk add --no-cache bash zip aws-cli

RUN adduser -D -u 1000 -g 1000 anil  # Replace 1000 with the correct UID and GID for your runner

WORKDIR /home/anil

COPY entrypoint.sh /home/anil/entrypoint.sh

RUN chown anil:anil /home/anil/entrypoint.sh
RUN chmod +x /home/anil/entrypoint.sh
RUN chown -R anil:anil /home/anil

USER anil

CMD ["bash", "/home/anil/entrypoint.sh"]
