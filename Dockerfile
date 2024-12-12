FROM python:3.12-slim

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --system appgroup && adduser --system --ingroup appgroup --home /home/appuser appuser

RUN chown -R appuser:appgroup /usr/src/app

USER root

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.py ./
RUN chown appuser:appgroup entrypoint.py

USER appuser

ENV HOME=/home/appuser

ENTRYPOINT ["python3", "/usr/src/app/entrypoint.py"]
