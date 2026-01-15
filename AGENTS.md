# Agent instructions

These guidelines explain how to work with this repository.

## Repository structure
- Each container must live in its own top-level folder (for example, `dev-base/`).
- Every folder that contains a `Dockerfile` must include a sibling `README.md` describing the container, its purpose, and any scripts used by the image.
- All container `README.md` files must be linked from the repository root `README.md`.
- The root `README.md` must present containers in a table, with the first column linking to the container README and the second column limited to a maximum of two sentences.
- If you cannot infer the reason for a container or script from context, ask the repository owner before documenting or changing it.

## Documentation standards
- All code, markdown files, and comments must be written in English (UK).
- Keep README files concise and task-focused; include the entrypoint behaviour and key tools installed.

## Changes and safety
- Do not move or delete existing containers without explicit instruction.
- Prefer minimal edits that preserve existing behaviour unless a change is requested.
