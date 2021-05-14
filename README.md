# docker-zerotier-moon
<a href="https://github.com/rwv/docker-zerotier-moon/actions">
    <img src="https://img.shields.io/github/workflow/status/rwv/docker-zerotier-moon/docker_hub_latest" alt="GitHub Actions" />
</a>
<a href="https://hub.docker.com/r/seedgou/zerotier-moon">
    <img src="https://img.shields.io/docker/pulls/seedgou/zerotier-moon" alt="Docker Hub" />
    <img src="https://img.shields.io/docker/image-size/seedgou/zerotier-moon/latest" alt="Docker Image Size" />
</a>
<br>
A docker image to create ZeroTier moon in one setp.

## Usage

### Pull the image

```
docker pull seedgou/zerotier-moon
```

### Start a container

```
docker run --name zerotier-moon -d --restart always -p 9993:9993/udp seedgou/zerotier-moon -4 1.2.3.4
```
 
Replace `1.2.3.4` with your moon's IP.

To show your moon id, run

```
docker logs zerotier-moon
```

**Notice:**
When creating a new container, a new moon id will be generated. To persist the identity when creating a new container, see **Mount ZeroTier conf folder** below.

## Advanced usage

### Manage ZeroTier

```
docker exec zerotier-moon /zerotier-cli
```

### Mount ZeroTier conf folder

```
docker run --name zerotier-moon -d -p 9993:9993/udp -v ~/somewhere:/var/lib/zerotier-one seedgou/zerotier-moon -4 1.2.3.4 -6 2001:abcd:abcd::1
```

This will mount `~/somewhere` to `/var/lib/zerotier-one` inside the container, allowing your ZeroTier moon to presist the same moon id.  If you don't do this, when you start a new container, a new moon id will be generated.

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

This image supports `linux/386`, `linux/amd64` and `linux/ppc64le`.
