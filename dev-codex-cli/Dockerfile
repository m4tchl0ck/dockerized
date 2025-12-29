FROM m4tchl0ck/dev-typescript:latest

# Upgrade OS packages to their latest versions
RUN sudo apt update && sudo apt upgrade -y

# Install zsh
RUN apt install -y zsh && \
    chsh -s $(which zsh)

# Install OpenAI Codex CLI
RUN npm install -g @openai/codex

# Install mcp-server
RUN npm install -g mcp-remote

# Add session picker script as the container entrypoint.
COPY run-codex.sh /usr/local/bin/run-codex
RUN chmod +x /usr/local/bin/run-codex

ENTRYPOINT ["run-codex"]