FROM m4tchl0ck/dev-base:latest

# Add Node.js LTS (v22)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g typescript ts-node tsx
