# docker-zerotier-moon

[![Docker](https://github.com/rwv/docker-zerotier-moon/actions/workflows/ci.yml/badge.svg)](https://github.com/rwv/docker-zerotier-moon/actions/workflows/ci.yml)
[![Docker Version](https://img.shields.io/docker/v/seedgou/zerotier-moon?sort=semver)](https://hub.docker.com/r/seedgou/zerotier-moon)
[![Docker Pulls](https://img.shields.io/docker/pulls/seedgou/zerotier-moon)](https://hub.docker.com/r/seedgou/zerotier-moon)
[![Docker Image Size](https://img.shields.io/docker/image-size/seedgou/zerotier-moon/latest)](https://hub.docker.com/r/seedgou/zerotier-moon)

A docker image to create a ZeroTier moon in one step.

This image now inherits ZeroTier from the official [`zerotier/zerotier`](https://hub.docker.com/r/zerotier/zerotier/tags) base image instead of installing `zerotier-one` from Alpine packages.

Have a look at dockerized ZeroTier: [rwv/zerotier](https://github.com/rwv/docker-zerotier).

## Table of Contents

- [Quickstart](#quickstart)
  - [Docker Run](#docker-run)
  - [Docker Compose](#docker-compose)
  - [Show ZeroTier moon id](#show-zerotier-moon-id)
- [Advanced usage](#advanced-usage)
  - [Manage ZeroTier](#manage-zerotier)
  - [Mount ZeroTier conf folder](#mount-zerotier-conf-folder)
  - [IPv6 support](#ipv6-support)
  - [Custom port](#custom-port)
  - [Network privilege](#network-privilege)
  - [Multi-arch support](#multi-arch-support)
  - [GitHub Container Registry](#github-container-registry)

## Quickstart

### Docker Run

```bash
docker run --name zerotier-moon -d --restart always \
  -p 9993:9993/udp \
  -v ~/somewhere:/var/lib/zerotier-one \
  seedgou/zerotier-moon:latest \
  -4 1.2.3.4
```

Replace `1.2.3.4` with your moon's IPv4 address and replace `~/somewhere` with where you would like to store ZeroTier state.

### Docker Compose

`compose.yml` example:

```yaml
services:
  zerotier-moon:
    image: seedgou/zerotier-moon:latest
    container_name: zerotier-moon
    restart: unless-stopped
    ports:
      - "9993:9993/udp"
    volumes:
      - ./config:/var/lib/zerotier-one
    command:
      - "-4"
      - "1.2.3.4"
      - "-p"
      - "9993"
```

Replace `1.2.3.4` with your public IPv4 address and adjust `./config`, image, or port mapping if needed.

Then start the container:

```bash
docker compose up -d
```

### Show ZeroTier moon id

```bash
docker logs zerotier-moon
```

Or, if you started it with Docker Compose:

```bash
docker compose logs -f zerotier-moon
```

## Advanced usage

### Manage ZeroTier

```bash
docker exec zerotier-moon zerotier-cli
```

### Mount ZeroTier conf folder

```bash
docker run --name zerotier-moon -d \
  -p 9993:9993/udp \
  -v ~/somewhere:/var/lib/zerotier-one \
  seedgou/zerotier-moon:latest \
  -4 1.2.3.4
```

When creating a new container without mounting ZeroTier conf folder, a new moon id will be generated. This command will mount `~/somewhere` to `/var/lib/zerotier-one` inside the container, allowing your ZeroTier moon to persist the same moon id. If you don't do this, when you start a new container, a new moon id will be generated.

### IPv6 support

```bash
docker run --name zerotier-moon -d \
  -p 9993:9993/udp \
  seedgou/zerotier-moon:latest \
  -4 1.2.3.4 \
  -6 2001:abcd:abcd::1
```

Replace `1.2.3.4`, `2001:abcd:abcd::1` with your moon's IP. You can remove `-4` option in pure IPv6 environment.
For Docker Compose, add `- "-6"` and your IPv6 address under `command` in the example above.

### Custom port

```bash
docker run --name zerotier-moon -d \
  -p 9994:9993/udp \
  seedgou/zerotier-moon:latest \
  -4 1.2.3.4 \
  -p 9994
```

Replace 9994 with your own custom port for ZeroTier moon.
If you use Docker Compose, update both the published port and the `-p` value in `command`.

### Network privilege

If you encounter issue: `ERROR: unable to configure virtual network port: could not open TUN/TAP device: No such file or directory`, please add `--cap-add=NET_ADMIN --cap-add=SYS_ADMIN --device=/dev/net/tun` args. Similar to this:

```bash
docker run --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --device=/dev/net/tun \
  --name zerotier-moon -d --restart always \
  -p 9993:9993/udp \
  seedgou/zerotier-moon:latest \
  -4 1.2.3.4
```

Solution provided by [Jonnyan404's Fork](https://github.com/Jonnyan404/docker-zerotier-moon).
See Also [Issue #1](https://github.com/rwv/docker-zerotier-moon/issues/1).
If you use Docker Compose, add `cap_add` and `devices` to the service definition when your host requires TUN/TAP access.

### Multi-arch support

This image supports `linux/386`, `linux/amd64`, `linux/arm/v7`, `linux/arm64`, `linux/mips64le`, `linux/ppc64le`, and `linux/s390x`.

### GitHub Container Registry

This image is also published on GitHub Container Registry: [`ghcr.io/rwv/zerotier-moon`](https://ghcr.io/rwv/zerotier-moon)

To use it with Docker Compose, replace `image: seedgou/zerotier-moon:latest` with `image: ghcr.io/rwv/zerotier-moon:latest`.
