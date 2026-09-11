#!/bin/sh
# Container entrypoint: start sshd, then hand over to the container command.
#
# sshd is started here rather than from a login shell because a container's
# command often never opens one — the agent runner, for example, execs a work
# loop that never reads a profile.
set -eu

# Accounts that AUTHORIZED_KEYS is installed for. Defaults to every login
# account (uid >= 1000); set SSH_USERS to a space separated list to pin it.
# root is deliberately excluded: logging in as an unprivileged account and
# escalating leaves a record, and root has no directly authenticatable path.
ssh_users() {
    if [ -n "${SSH_USERS:-}" ]; then
        printf '%s\n' $SSH_USERS
        return 0
    fi

    getent passwd | while IFS=: read -r user _ uid _ _ _ _; do
        if [ "$uid" -ge 1000 ] && [ "$uid" -lt 65534 ]; then
            printf '%s\n' "$user"
        fi
    done
}

install_authorized_keys() {
    [ -n "${AUTHORIZED_KEYS:-}" ] || return 0

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
