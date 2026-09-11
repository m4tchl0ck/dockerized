FROM m4tchl0ck/dev-base:latest

# Add external apt repos: .NET (dev-dotnet), Node.js LTS (dev-node)
# The Debian 13 (trixie) prod repo is signed with a key absent from the stale
# keys/microsoft.asc, so take the current key from the official config deb.
RUN install -m 0755 -d /etc/apt/keyrings \
    && . /etc/os-release \
    && curl -fsSL "https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb" -o /tmp/pmp.deb \
    && dpkg-deb --fsys-tarfile /tmp/pmp.deb | tar -xO usr/share/keyrings/microsoft-prod.gpg > /etc/apt/keyrings/microsoft.gpg \
    && rm /tmp/pmp.deb \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/$VERSION_ID/prod $VERSION_CODENAME main" \
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
# Claude Code — install image-wide via the official installer rather than a global
# npm package, so it survives a bind-mounted /home/vscode. Pin the version and bound
# the download; a blackholed build network otherwise costs 10 min before it fails.
RUN curl -fsSL --retry 5 --retry-all-errors --connect-timeout 10 --max-time 300 \
         https://claude.ai/install.sh | HOME=/opt/claude bash -s 2.1.177 \
    && ln -sf /opt/claude/.local/bin/claude /usr/local/bin/claude \
    && chown -R vscode:vscode /opt/claude
RUN curl -fsSL https://opencode.ai/install | bash
