FROM m4tchl0ck/dev-full:latest

RUN useradd -m -s /bin/zsh -G sudo,docker developer \
    && echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer \
    && chmod 0440 /etc/sudoers.d/developer
