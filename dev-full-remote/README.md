# dev-full-remote

[dev-full](../dev-full) made safe to expose to the internet, such as an Azure
Container Instance with a public IP. It changes nothing in dev-full itself, so
local devcontainer use of that image is unaffected.

It exists for unattended agent work, which needs both halves at once: dev-full's
.NET, Node, Python, `gh`, `gnupg` and Claude Code to do the work, and a public
address to be reachable over SSH while doing it.

## Build

```sh
docker build --build-arg BASE_VERSION=0.1.2 -t m4tchl0ck/dev-full-remote:0.1.2 .
```

`BASE_VERSION` defaults to `latest`; pin it to make a rebuild reproducible.
`build-all.sh` builds this in layer 3, after dev-full exists.

## What it changes

**The SSH server.** Installs `openssh-server`, which dev-base does not ship,
and the entrypoint that starts it. Debian generates host keys when the package
is installed; they are deleted again, so every container generates its own on
first start rather than every container from this image sharing one identity.

**Accounts.** Adds the unprivileged `app` account (uid 1100) that the cloud
sshd profile names as its only SSH target, and locks `vscode`.
The upstream devcontainer image grants `vscode` `NOPASSWD:ALL`, which would
make the rest of this list decorative — an SSH key holder could read the
container's secrets straight out of `/proc/1/environ` with `sudo cat`. That
grant is removed. `SSH_USERS=app` restricts the accounts the entrypoint
authorises, whatever accounts a later package adds.

**sshd policy** (`sshd-cloud.conf`, installed as
`/etc/ssh/sshd_config.d/10-cloud.conf`). The only drop-in in the image, so the
effective policy is what this one file says — there is nothing inherited to
merge with, because the server is installed here too. `sshd -t` validates it at
build time. It is complete on its own, including the basics Debian's
`sshd_config` would otherwise decide (`Port 22`, `PubkeyAuthentication yes`,
`PasswordAuthentication no`, `KbdInteractiveAuthentication no` — the last two
matter, since Debian's defaults permit both). Relative to a stock sshd:

| Directive | Value | Reason |
| --- | --- | --- |
| `PermitRootLogin` | `no` | root has no directly authenticatable path |
| `AllowUsers` | `app` | one SSH target, regardless of accounts added later |
| `AuthorizedKeysFile` | `/etc/ssh/authorized_keys.d/%u` only | a logged-in user cannot authorise further keys for themselves |
| `AuthenticationMethods` | `publickey` | forecloses any PAM-based path a later package might enable |
| `MaxAuthTries` | `3` | each *offered* key counts, so 3 still allows a couple of wrong ones |
| `LoginGraceTime` | `30` | caps how long an unauthenticated connection holds a slot |
| `MaxStartups` | `10:30:30` | drops the unauthenticated tail from 100 |
| `ClientAliveInterval` / `ClientAliveCountMax` | `60` / `3` | drops dead sessions instead of leaving them pinned open; a sleeping laptop is the common case |
| `LogLevel` | `VERBOSE` | logs the fingerprint of the key that authenticated |
| `AllowTcpForwarding` | `no` | see below |
| `AllowAgentForwarding`, `X11Forwarding`, `PermitTunnel` | `no` | unused here, and each is a way out of the session |

### Why one drop-in, and why it is self-contained

sshd takes the **first** value it sees for most keywords and reads
`sshd_config.d/*.conf` in lexical order, so drop-ins resolve against each other
by filename rather than by intent. An earlier arrangement had this policy
override a development profile inherited from dev-base, which left it depending
on four directives from the file it was contradicting — `PasswordAuthentication
no` among them. Installing the server here, with a single complete drop-in,
means there is nothing to resolve, no prefix whose name is load bearing, and
one file to read to know what sshd will do.

**Accounts, continued.** The locked `vscode` account is also the account
dev-full installed Claude Code for
(`chown -R vscode:vscode /opt/claude`). The tree stays world-readable, so `app`
can still run `/usr/local/bin/claude`; it writes its state under `app`'s own
home.

**No first-login setup.** The `setup-dev` hook is removed from `/etc/zsh/zlogin`;
it prompts for `gh auth login` and offers to pipe a remote installer into a
shell, which is wrong on a host with a public address.

## Entrypoint and sshd

`entrypoint.sh` (installed as `/usr/local/bin/entrypoint`) runs first, then
execs the container command. It starts sshd there rather than from a login
shell because the container command often never opens one — the agent runner
execs a work loop that reads no profile.

Authorised keys come from `/etc/ssh/authorized_keys.d/<user>`, which the
entrypoint writes from the `AUTHORIZED_KEYS` environment variable for the
accounts named by `SSH_USERS` (`app` here). root is never authorised, so
escalate with `sudo -i` after logging in — which in this image means not at
all, since `app` has no sudo grant.

Both `AUTHORIZED_KEYS` and `SSH_USERS` are **required**: the entrypoint exits
non-zero before starting anything if either is unset or empty. An image that
exists to be reached over the network should refuse to boot with no authorised
key rather than come up as a public sshd nobody can enter. `SSH_USERS` defaults
to `app` from the image, so in practice only `AUTHORIZED_KEYS` must be supplied
at run time:

```sh
docker run -e AUTHORIZED_KEYS="$(cat ~/.ssh/id_ed25519.pub)" ... m4tchl0ck/dev-full-remote
```

Pass several newline-separated keys to authorise more than one client.

sshd starts only when the container runs as root, and only then can it bind
port 22 and write root-owned key files before dropping to the session user.

It runs as `sshd -D -e`, so authentication successes and failures appear in
`docker logs` and `az container logs`. Both flags are needed: without `-D`,
sshd daemonises through `daemon(0,0)`, which reopens stderr on `/dev/null` and
discards the log — `-e` on its own is silently useless.

## Deployment notes

**Port 22 on a public IP is the risk this image mitigates, not one it
removes.** ACI cannot be protected by a network security group unless it is
VNet-integrated, in which case the address is not public. Prefer
`az container exec` for shell access, or VNet integration behind an NSG. Use
this image when public SSH is a requirement you have accepted.

**Host keys.** dev-base generates them per container, so on ACI every restart
changes the fingerprint — clients then warn on every connect, which trains
people to accept unknown keys and removes SSH's only defence against a
man-in-the-middle on a public endpoint. Mount a persistent key over
`/etc/ssh/ssh_host_ed25519_key`; the entrypoint only creates keys that are
missing.

**Secrets.** Environment variables are readable from `/proc/1/environ` by root
and by anyone who can escalate to it. Prefer an ACI secret volume and read the
value from a file. The secret still appears base64-encoded in the deployment
payload and in Terraform state, so this reduces in-container exposure rather
than eliminating exposure entirely.

**Forwarding is off for a reason.** With `AllowTcpForwarding yes`, anyone who
can log in can tunnel to the Azure instance metadata service at
`169.254.169.254` and request tokens for the container group's managed
identity, and use the container as a pivot into any network it can reach.

**Never mount the Docker socket into this container.** See
[dev-base](../dev-base/README.md#the-docker-socket).
