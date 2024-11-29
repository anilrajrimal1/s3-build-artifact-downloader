FROM python:3.12-slim

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.py .

ENTRYPOINT ["python3", "/usr/src/app/entrypoint.py"]
