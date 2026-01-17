ARG HOME=/root

FROM alpine:3.23

RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    bat \
    btop \
    eza \
    fzf \
    jless \
    jq \
    ripgrep \
    mc \
    bash \
    zsh \
    musl-locales \
    musl-locales-lang

RUN apk add --no-cache \
    gnupg \
    github-cli

ENV SHELL=/bin/zsh
ENV LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
SHELL ["/bin/zsh", "-lc"]
CMD ["zsh"]

RUN apk add --no-cache \
    neovim \
    && git clone https://github.com/LazyVim/starter $HOME/.config/nvim \
    && rm -rf $HOME/.config/nvim/.git

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin \
    && echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.zshrc

# Add dev-setup script.
COPY dev-setup.sh /usr/local/bin/dev-setup
RUN chmod +x /usr/local/bin/dev-setup

# Add entrypoint wrapper.
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

