FROM alpine:latest

RUN apk update && apk add --no-cache bash

RUN adduser -D anil

WORKDIR /home/anil

COPY entrypoint.sh /home/anil/entrypoint.sh

RUN chown anil:anil /home/anil/entrypoint.sh

RUN chmod +x /home/anil/entrypoint.sh

USER anil

CMD ["bash", "/home/anil/entrypoint.sh"]
