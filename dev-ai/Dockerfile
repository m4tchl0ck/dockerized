FROM m4tchl0ck/dev-base:latest

# Node.js LTS (v22)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# AI CLI tools (split into separate layers to avoid large blob push failures)
RUN npm install -g mcp-remote
RUN npm install -g @openai/codex
# Claude Code — install image-wide via the official installer rather than a global
# npm package, so it survives a bind-mounted /home/vscode. Pin the version and bound
# the download; a blackholed build network otherwise costs 10 min before it fails.
RUN curl -fsSL --retry 5 --retry-all-errors --connect-timeout 10 --max-time 300 \
         https://claude.ai/install.sh | HOME=/opt/claude bash -s 2.1.177 \
    && ln -sf /opt/claude/.local/bin/claude /usr/local/bin/claude \
    && chown -R vscode:vscode /opt/claude
RUN curl -fsSL https://opencode.ai/install | bash
