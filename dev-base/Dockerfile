ARG HOME=/root

FROM mcr.microsoft.com/devcontainers/base:debian

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8

# Add external apt repos: Docker CLI, .NET, Node.js LTS
RUN install -m 0755 -d /etc/apt/keyrings \
    # Docker CLI
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" \
       > /etc/apt/sources.list.d/docker.list \
    # Microsoft (.NET)
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
       > /etc/apt/sources.list.d/microsoft.list \
    # Node.js LTS (v22)
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

RUN apt-get update && apt-get install -y --no-install-recommends \
    bat ripgrep \
    btop \
    eza \
    fzf \
    mc \
    gnupg2 scdaemon pinentry-curses socat \
    docker-ce-cli \
    postgresql-client \
    python3 python3-pip python3-venv python3-yaml \
    nodejs \
    dotnet-sdk-10.0 \
    neovim \
    chromium \
    fonts-noto-color-emoji fonts-freefont-ttf \
    libfreetype6 libharfbuzz0b libnss3 \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

# jless (no apt package)
RUN JLESS_VERSION=$(curl -fsSL https://api.github.com/repos/PaulJuliusMartinez/jless/releases/latest | jq -r '.tag_name') \
    && curl -fsSL "https://github.com/PaulJuliusMartinez/jless/releases/download/${JLESS_VERSION}/jless-${JLESS_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
       | tar xz -C /usr/local/bin/

# act (no apt package)
RUN curl -fsSL https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- -b /usr/local/bin

# AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

# TypeScript
RUN npm install -g typescript ts-node tsx

# chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# LazyVim
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim \
    && rm -rf /root/.config/nvim/.git

SHELL ["/bin/zsh", "-lc"]
CMD ["zsh"]

# Add dev-setup script.
COPY setup-dev.sh /usr/local/bin/setup-dev
RUN chmod +x /usr/local/bin/setup-dev

# Add entrypoint wrapper.
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
