FROM ubuntu:22.04

RUN apt-get update && apt-get install -y unzip awscli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER root

ENTRYPOINT ["/entrypoint.sh"]
