FROM python:3.12-slim

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 github && \
    useradd -u 1001 -g github -m github

USER github

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.py .

ENTRYPOINT ["python3", "/usr/src/app/entrypoint.py"]
