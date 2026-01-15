FROM node:20-slim

# Install Allure v3 CLI globally
ARG ALLURE_VERSION=3.0.1
RUN npm install -g allure@${ALLURE_VERSION}

# Set up working directory
ENV ROOT=/app
WORKDIR $ROOT

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
