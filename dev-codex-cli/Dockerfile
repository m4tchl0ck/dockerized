FROM m4tchl0ck/dev-node:latest

# Install OpenAI Codex CLI
RUN npm install -g @openai/codex

# Install mcp-server
RUN npm install -g mcp-remote

# Add session picker script.
COPY run-codex.sh /usr/local/bin/run-codex
RUN chmod +x /usr/local/bin/run-codex

# Add entrypoint wrapper to run dev-setup first.
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
