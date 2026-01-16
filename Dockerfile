FROM node:20-slim

# Set up working directory
ENV ROOT=/app
WORKDIR $ROOT

# Copy package.json and install Allure v3 CLI
COPY package.json ./
RUN npm install -g allure@$(node -p "require('./package.json').dependencies.allure")

# Copy Allure configuration
COPY allurerc.json /allurerc.json

# Copy history bootstrap script
COPY history-bootstrap.sh /history-bootstrap.sh
RUN chmod +x /history-bootstrap.sh

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
