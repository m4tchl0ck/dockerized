FROM m4tchl0ck/dev-node:latest

RUN apk update 
    
RUN apk add --no-cache \
    dotnet10-sdk

# AI tools
RUN npm install -g mcp-remote \
    && npm install -g @openai/codex \
    && curl -fsSL https://opencode.ai/install | bash \
    && curl -fsSL https://claude.ai/install.sh | bash

RUN apk add aws-cli

