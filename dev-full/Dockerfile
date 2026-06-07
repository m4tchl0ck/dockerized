FROM m4tchl0ck/dev-base:latest

# Add external apt repos: .NET (dev-dotnet), Node.js LTS (dev-node)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
       > /etc/apt/sources.list.d/microsoft.list \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

# dev-python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python3-yaml \
    && rm -rf /var/lib/apt/lists/*

# dev-node
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# dev-dotnet
RUN apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-10.0 \
    && rm -rf /var/lib/apt/lists/*

# dev-typescript
RUN npm install -g typescript ts-node tsx

# dev-ai
RUN npm install -g mcp-remote
RUN npm install -g @openai/codex
RUN npm install -g @anthropic-ai/claude-code
RUN curl -fsSL https://opencode.ai/install | bash
