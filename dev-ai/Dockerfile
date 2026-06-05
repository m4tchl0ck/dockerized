FROM m4tchl0ck/dev-base:latest

# Node.js LTS (v22)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# AI CLI tools
RUN npm install -g \
    mcp-remote \
    @openai/codex \
    @anthropic-ai/claude-code \
    && curl -fsSL https://opencode.ai/install | bash
