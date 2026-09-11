ARG BASE_VERSION=latest
FROM m4tchl0ck/dev-full:${BASE_VERSION}

# The SSH server, which dev-base deliberately does not ship. Debian generates
# host keys when the package is installed; they are deleted again so every
# container generates its own on first start rather than sharing an identity
# baked into the image.
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && find /etc/ssh -name "ssh_host_*" -delete

# An unprivileged account with no sudo grant. dev-base inherits vscode with
# NOPASSWD:ALL from the upstream devcontainer image, which would make every
# boundary below decorative: an SSH key holder could read the secrets of
# PID 1 straight out of /proc/1/environ.
RUN useradd -m -s /bin/zsh -u 1100 app \
    && rm -f /etc/sudoers.d/vscode \
    && usermod -L -s /usr/sbin/nologin vscode

# Only the app account is an SSH target, whatever accounts a later package adds.
ENV SSH_USERS=app

# setup-dev prompts for `gh auth login` and offers to pipe a remote installer
# into a shell on first interactive login. That belongs in a development
# container, not on a host with a public address.
RUN sed -i -e '/setup-dev-init/d' /etc/zsh/zlogin

# The only sshd drop-in in the image, so its effective policy is what this one
# file says — nothing inherited, and no filename ordering to reason about.
#
# Validate at build time. sshd -t needs host keys present, so generate
# throwaway ones and delete them again — the image must ship without a host
# identity.
COPY sshd-cloud.conf /etc/ssh/sshd_config.d/10-cloud.conf
RUN chmod 0644 /etc/ssh/sshd_config.d/10-cloud.conf \
    && ssh-keygen -A >/dev/null \
    && sshd -t \
    && find /etc/ssh -name "ssh_host_*" -delete

# Starts sshd, then execs the container command.
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 22

# The entrypoint stays root: it binds port 22 and writes root owned key files
# before sshd drops to the session user. Sessions land as app, which is
# unprivileged, so do not add a USER directive here.
ENTRYPOINT ["/usr/local/bin/entrypoint"]
