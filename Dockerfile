#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -f Dockerfile -t bnhf/nut-cgi:latest . --push --no-cache
FROM debian:12-slim

# Environment vars needed by Apache
ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    nut-cgi \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/nut

# Copy NUT config files to /opt/nut to be copied by start.sh
COPY ./config/ /opt/nut/
COPY start.sh .
RUN chmod +x start.sh

# Expose default NUT port
EXPOSE 80

# Set the container entrypoint
CMD ["./start.sh"]
