# docker-zerotier-moon
A docker image to create ZeroTier moon in one setp.

## Usage

```
docker run --name zerotier-moon -d -p 9993:9993 -p 9993:9993/udp seedgou/zerotier-moon -4 1.2.3.4
```
 
Replace `1.2.3.4` by your moon's IP.

To show your moon id, run

```
docker logs zerotier-moon
```

**Notice:**
When you create a new container, a new moon id will be generated. In order to persist the moon id, use `docker start zerotier-moon` when the container is down. To persist the identity when creating a new container, see **Mount ZeroTier conf folder** below.

## Advanced usage

### Manage Zerotier

```
docker exec zerotier-moon /zerotier-cli
```

### Mount ZeroTier conf folder

```
docker run --name zerotier-moon -d -p 9993:9993 -p 9993:9993/udp -v ~/somewhere:/var/lib/zerotier-one seedgou/zerotier-moon -4 1.2.3.4 -6 2001:abcd:abcd::1
```

This will mount `~/somewhere` to `/var/lib/zerotier-one` inside the container, allowing your ZeroTier moon to presist the same moon id.  If you don't do this, when you start a new container, a new moon id will be generated.

## IPv6 support

```
docker run --name zerotier-moon -d -p 9993:9993 -p 9993:9993/udp seedgou/zerotier-moon -4 1.2.3.4 -6 2001:abcd:abcd::1
```

Replace `1.2.3.4`, `2001:abcd:abcd::1` by your moon's IP. You can remove `-4` optional in pure IPv6 environment.

