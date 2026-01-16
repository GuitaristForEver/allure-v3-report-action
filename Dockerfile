FROM node:20-slim

# Set up working directory
ENV ROOT=/app
WORKDIR $ROOT

# Copy package.json and install Allure v3 CLI
COPY package.json ./
RUN npm install -g allure@$(node -p "require('./package.json').dependencies.allure")

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
