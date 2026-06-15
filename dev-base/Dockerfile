ARG HOME=/root

FROM mcr.microsoft.com/devcontainers/base:debian

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8

# Add external apt repo: Docker CLI
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" \
       > /etc/apt/sources.list.d/docker.list \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    bat ripgrep \
    btop \
    eza \
    fzf \
    mc \
    gnupg2 scdaemon pinentry-curses socat \
    docker-ce-cli \
    gh \
    locales \
    postgresql-client \
    neovim \
    chromium \
    fonts-noto-color-emoji fonts-freefont-ttf \
    libfreetype6 libharfbuzz0b libnss3 \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

# Debian's locale-gen ignores arguments and only builds locales uncommented in
# /etc/locale.gen, so uncomment en_GB.UTF-8 before generating it.
RUN sed -i -e 's/# *en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8

# act (no apt package)
RUN curl -fsSL https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- -b /usr/local/bin

# AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/awscliv2.zip /tmp/aws

# chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# LazyVim
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim \
    && rm -rf /root/.config/nvim/.git

RUN chsh -s /bin/zsh vscode

SHELL ["/bin/zsh", "-lc"]
CMD ["zsh"]

# Add dev-setup script.
COPY setup-dev.sh /usr/local/bin/setup-dev
RUN chmod +x /usr/local/bin/setup-dev

# Run setup-dev on first login for any user.
COPY setup-dev-init.sh /etc/profile.d/setup-dev-init.sh
RUN chmod +x /etc/profile.d/setup-dev-init.sh \
    && echo 'source /etc/profile.d/setup-dev-init.sh' >> /etc/zsh/zlogin
