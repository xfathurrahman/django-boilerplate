# syntax=docker/dockerfile:1
FROM python:3.12

# Environment setup
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV TINI_SUBREAPER 1
ENV BASE_DIR "/app/src/"
ENV PYTHONPATH "/app/:/app/src/"

# Create directories and initial environment
RUN mkdir -p /app /app/logs /app/src /app/config \
             /app/staticfiles /app/mediafiles
WORKDIR /app/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    netcat-traditional \
    tini

# Python packages
RUN pip install --upgrade pip
COPY config/requirements/requirements.txt /app
RUN pip install -r /app/requirements.txt

# Copy entrypoint
COPY config/docker/run.sh /app
RUN chmod +x /app/run.sh

# Copy app
COPY web/django /app/src
COPY web/static /app/static
COPY config/django /app/src/config
COPY config/pytest.ini /app

# Final environment
RUN groupadd app
RUN useradd -g app -d /app app
RUN chown app -R /app
USER app

# Entrypoint
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/app/run.sh", "start"]
