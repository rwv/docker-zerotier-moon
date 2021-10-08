# docker-zerotier-moon

<a href="https://github.com/rwv/docker-zerotier-moon/actions">
    <img src="https://img.shields.io/github/workflow/status/rwv/docker-zerotier-moon/Docker" alt="GitHub Actions" />
</a>
<a href="https://hub.docker.com/r/seedgou/zerotier-moon">
    <img src="https://img.shields.io/docker/v/seedgou/zerotier-moon?sort=semver" alt="Docker Version" />
    <img src="https://img.shields.io/docker/pulls/seedgou/zerotier-moon" alt="Docker Hub" />
    <img src="https://img.shields.io/docker/image-size/seedgou/zerotier-moon/latest" alt="Docker Image Size" />
</a>
<br>
A docker image to create ZeroTier moon in one setp.

Have a look at dockerized ZeroTier: [rwv/zerotier](https://github.com/rwv/docker-zerotier).

## Table of Contents

- [Quickstart](#quickstart)
  - [Start a container](#start-a-container)
  - [Show ZeroTier moon id](#show-zerotier-moon-id)
- [Docker Compose](#docker-compose)
  - [Compose file](#compose-file)
  - [Show ZeroTier moon id](#show-zerotier-moon-id-1)
- [Advanced usage](#advanced-usage)
  - [Manage ZeroTier](#manage-zerotier)
  - [Mount ZeroTier conf folder](#mount-zerotier-conf-folder)
  - [IPv6 support](#ipv6-support)
  - [Custom port](#custom-port)
  - [Network privilege](#network-privilege)
  - [Multi-arch support](#multi-arch-support)
  - [GitHub Container Registry](#github-container-registry)

## Quickstart

### Start a container

```
docker run --name zerotier-moon -d --restart always -p 9993:9993/udp -v ~/somewhere:/var/lib/zerotier-one seedgou/zerotier-moon -4 1.2.3.4
```

Replace `1.2.3.4` with your moon's IPv4 address and replace `~/somewhere` with where you would like to store your configuration.

### Show ZeroTier moon id

```
docker logs zerotier-moon
```

## Docker Compose

### Compose file

`docker-compose.yml` example:

``` YAML
version: "3"

services:
  zerotier-moon:
    image: seedgou/zerotier-moon
    container_name: "zerotier-moon"
    restart: always
    ports:
      - "9993:9993/udp"
    volumes:
      - ./config:/var/lib/zerotier-one
    entrypoint:
      - /startup.sh
      - "-4"
      - 1.2.3.4
```

Replace `1.2.3.4` with your moon's IPv4 address.

### Show ZeroTier moon id

``` bash
docker-compose logs
```

## Advanced usage

### Manage ZeroTier

```
docker exec zerotier-moon zerotier-cli
```

### Mount ZeroTier conf folder

```
docker run --name zerotier-moon -d -p 9993:9993/udp -v ~/somewhere:/var/lib/zerotier-one seedgou/zerotier-moon -4 1.2.3.4 
```

When creating a new container without mounting ZeroTier conf folder, a new moon id will be generated. This command will mount `~/somewhere` to `/var/lib/zerotier-one` inside the container, allowing your ZeroTier moon to presist the same moon id. If you don't do this, when you start a new container, a new moon id will be generated.

### IPv6 support

```
docker run --name zerotier-moon -d -p 9993:9993/udp seedgou/zerotier-moon -4 1.2.3.4 -6 2001:abcd:abcd::1
```

Replace `1.2.3.4`, `2001:abcd:abcd::1` with your moon's IP. You can remove `-4` option in pure IPv6 environment.

### Custom port

```
docker run --name zerotier-moon -d -p 9994:9993/udp seedgou/zerotier-moon -4 1.2.3.4 -p 9994
```

Replace 9994 with your own custom port for ZeroTier moon.

### Network privilege

If you encounter issue: `ERROR: unable to configure virtual network port: could not open TUN/TAP device: No such file or directory`, please add `--cap-add=NET_ADMIN --cap-add=SYS_ADMIN --device=/dev/net/tun` args. Similar to this:

```
docker run --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --device=/dev/net/tun --name zerotier-moon -d --restart always -p 9993:9993/udp seedgou/zerotier-moon -4 1.2.3.4
```

Solution provided by [Jonnyan404's Fork](https://github.com/Jonnyan404/docker-zerotier-moon).
See Also [Issue #1](https://github.com/rwv/docker-zerotier-moon/issues/1).

### Multi-arch support

This image supports `linux/386`, `linux/amd64`, `linux/ppc64le`, `linux/arm64`, `linux/arm/v7`, `linux/arm/v6` and `linux/s390x`.

### GitHub Container Registry

This image is also published on GitHub Container Registry: [`ghcr.io/rwv/zerotier-moon`](https://ghcr.io/rwv/zerotier-moon)
