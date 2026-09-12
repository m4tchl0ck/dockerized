#!/bin/sh
# Container entrypoint: start sshd, then hand over to the container command.
#
# sshd is started here rather than from a login shell because a container's
# command often never opens one — the agent runner, for example, execs a work
# loop that never reads a profile.
set -eu

# dev-full-remote exists to be reached over the network, so starting it without
# knowing who may log in and with which key is a misconfiguration, not a
# default — a public sshd with no authorised key just invites brute force.
# Refuse to start unless both are set. ${var:?msg} exits non-zero, writing msg
# to stderr, when the variable is unset or empty.
: "${AUTHORIZED_KEYS:?refusing to start: set it to the authorised SSH public key(s)}"
: "${SSH_USERS:?refusing to start: set it to the login account(s) allowed over SSH}"

# Accounts that AUTHORIZED_KEYS is installed for, as a space separated list.
# root is deliberately excluded: logging in as an unprivileged account and
# escalating leaves a record, and root has no directly authenticatable path.
ssh_users() {
    printf '%s\n' $SSH_USERS
}

install_authorized_keys() {
    install -d -m 0755 /etc/ssh/authorized_keys.d

    ssh_users | while read -r user; do
        if ! id "$user" >/dev/null 2>&1; then
            echo "entrypoint: no such user '$user', skipping" >&2
            continue
        fi
        printf '%s\n' "$AUTHORIZED_KEYS" > "/etc/ssh/authorized_keys.d/$user"
        chmod 0644 "/etc/ssh/authorized_keys.d/$user"
    done
}

start_sshd() {
    # Host keys are generated per container rather than baked into the image,
    # so containers started from the same image do not share an identity. Only
    # missing keys are created, so mounting a key over /etc/ssh pins the host
    # identity across restarts — worth doing wherever clients verify it.
    ssh-keygen -A >/dev/null

    install_authorized_keys

    install -d -m 0755 /run/sshd

    # -D -e keeps sshd in the foreground logging to stderr, so authentication
    # failures reach `docker logs`. Without -D, sshd daemonises through
    # daemon(0,0), which reopens stderr on /dev/null and discards the log —
    # -e alone is silently useless. It is backgrounded here so that the
    # container command stays PID 1.
    /usr/sbin/sshd -D -e &
}

if [ "$(id -u)" -eq 0 ]; then
    start_sshd || echo "entrypoint: sshd did not start" >&2
else
    echo "entrypoint: not running as root, sshd not started" >&2
fi

[ "$#" -gt 0 ] || set -- zsh
exec "$@"
