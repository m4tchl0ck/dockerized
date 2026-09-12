# dev-base

Base development container built on Debian with a minimal, fast CLI stack.

## Included tools
- zsh as the default shell
- curl, wget, ca-certificates
- GitHub CLI and GnuPG
- bat, btop, eza, fzf, jless, jq, ripgrep
- Neovim with LazyVim starter preloaded
- chezmoi installer (adds to PATH via .zshrc)
- `openssh-client` (via the devcontainers common-utils feature) — no server

## First login
On the first login of each user, `dev-setup` runs, which:
- checks GitHub CLI auth and runs `gh auth login` if needed
- optionally initializes dotfiles with chezmoi
- launches zsh

## SSH

There is **no SSH server** in this image, deliberately. A devcontainer is
entered through the editor or `docker exec`, so a listening daemon would be
weight every image above this one carries for a single consumer.
`openssh-client` is present, so outbound `ssh` and git over ssh work.

For a container reachable from the internet, use
[dev-full-remote](../dev-full-remote/README.md): it installs `openssh-server`,
ships the entrypoint that starts it, and owns the whole sshd policy.

## The docker socket
`docker-ce-cli` is installed. The binary alone is harmless, but **the Docker
socket must never be mounted into a container that is reachable from an
untrusted network.**

The Docker API has no privilege separation: access to the socket is equivalent
to root on the *host*, not root in the container. Anyone reaching it can run
`docker run -v /:/host --privileged` to read or write the whole host
filesystem, including other containers' data and any credentials on the box.
It also bypasses every constraint placed on this container, because no user
namespace, capability drop, or seccomp profile applies to a new container the
daemon is asked to create.

The devcontainer template mounts the socket, which is fine on a local machine.
The rule is that a socket mount and a publicly reachable port 22 must never
coexist in the same container.
