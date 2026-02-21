FROM m4tchl0ck/dev-base:latest

RUN apk update && apk upgrade \
    && apk add --no-cache \
    nodejs \
    npm \
    aws-cli \
    dotnet10-sdk

# AI tools
RUN npm install -g mcp-remote \
    && npm install -g @openai/codex \
    && curl -fsSL https://opencode.ai/install | bash \
    && curl -fsSL https://claude.ai/install.sh | bash

ENV USE_BUILTIN_RIPGREP=0

RUN apk add --no-cache 

