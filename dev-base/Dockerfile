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
    zsh

RUN apk add --no-cache \
    gnupg \
    github-cli

ENV SHELL=/bin/zsh
SHELL ["/bin/zsh", "-lc"]
CMD ["zsh"]

RUN apk add --no-cache \
    neovim \
    && git clone https://github.com/LazyVim/starter $HOME/.config/nvim \
    && rm -rf $HOME/.config/nvim/.git

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin \
    && echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.zshrc

COPY dev-setup.sh /usr/local/bin/dev-setup
RUN chmod +x /usr/local/bin/dev-setup

ENTRYPOINT [ "dev-setup" ]
