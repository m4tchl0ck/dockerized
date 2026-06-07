FROM m4tchl0ck/dev-base:latest

# Node.js LTS (v22)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# AI CLI tools (split into separate layers to avoid large blob push failures)
RUN npm install -g mcp-remote
RUN npm install -g @openai/codex
RUN npm install -g @anthropic-ai/claude-code
RUN curl -fsSL https://opencode.ai/install | bash
