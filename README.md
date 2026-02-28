# Example for how to create Docker image that updates itself on startup

This repository is an example of how to create a Docker image that updates itself on startup. The image is based on the
official Debian stable slim image. On each container start, it pulls the latest code from the Git repository, installs
system and Python dependencies, and runs the application.

The example application polls the [yesno.wtf](https://yesno.wtf/api) API every 10 seconds and exits based on the
response: exit code 0 for "yes" (container stops) or exit code 1 for "no" (container restarts when using
`--restart on-failure`). This demonstrates how an external API can indirectly control the container lifecycle.

## Motivation

A friend of mine was thinking about how to create a Docker image that updates itself. He wanted a container that always
runs the latest version of the software without the user needing to rebuild the image or manually update it. He also
wanted to control the restart of the container via an API response.

The simplest way I could think of was to create a Docker image that pulls the latest code on startup. Whenever the
container is started, it runs a `git pull` to fetch the newest changes, then installs any updated dependencies before
running the application. Combined with Docker's `--restart on-failure` policy, the container automatically restarts
(and re-pulls) whenever the application exits with a non-zero code.

## How it works

1. The container starts and [entrypoint.sh](entrypoint.sh) runs `git pull` to fetch the latest code
2. [update.sh](update.sh) installs/updates system packages and Python dependencies
3. [run.sh](run.sh) executes [main.py](main.py), which polls the yesno.wtf API every 10 seconds
4. On "yes", the container exits with code 0 (stops). On "no", it exits with code 1 (restarts via Docker restart policy)

## Branch switching

The container supports switching branches by writing a branch name to `current-branch.txt` in the repository.
On startup, [entrypoint.sh](entrypoint.sh) reads this file and pulls from that branch. If the file is missing or
contains an invalid branch name, it defaults to `main`.

This was a concept that I came up with later on, which is meant to be used in a way that the API would respond to the
container with a branch name, and the container would write that branch name to `current-branch.txt` before exiting.
This could come in handy if you want to have different versions of the software running in different containers, or if you want to
opt-in in a beta branch to test new features without affecting the main production branch.

## Usage

### Run locally with mock mode

```bash
docker build -t yesno-poller .
docker run -e MOCK=true --restart on-failure --name yesno-poller yesno-poller
```

### Run in production

```bash
docker run --pull always --restart on-failure --name yesno-poller kirbownz/yesno-poller:latest
```

### Build and push multi-platform image

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t kirbownz/yesno-poller:latest --push .
```

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MOCK`   | `false` | Set to `true` to use mock responses instead of the real API (20% yes, 80% no) |
