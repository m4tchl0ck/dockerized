ARG HOME=/root

FROM alpine:3.23

RUN apk update && apk upgrade \
    && apk add --no-cache \
    ca-certificates \
    curl wget \
    bat ripgrep \
    btop \
    eza \
    fzf \
    jless \
    jq \
    mc \
    zsh bash \
    musl-locales \
    musl-locales-lang \
    docker-cli \
    gnupg gnupg-scdaemon pinentry \
    github-cli \
    docker-cli

ENV SHELL=/bin/zsh
ENV LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
SHELL ["/bin/zsh", "-lc"]
CMD ["zsh"]

RUN apk add --no-cache \
    neovim \
    && git clone https://github.com/LazyVim/starter $HOME/.config/nvim \
    && rm -rf $HOME/.config/nvim/.git

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

RUN apk update \
    && apk add --no-cache \
    nodejs \
    npm

# Add dev-setup script.
COPY setup-dev.sh /usr/local/bin/setup-dev
RUN chmod +x /usr/local/bin/setup-dev

# Add entrypoint wrapper.
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

