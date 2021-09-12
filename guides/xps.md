# Dell XPS 15 9570

Following arch linux dell xps 15 9570 guide at [arch wiki](https://wiki.archlinux.org/title/Dell_XPS_15_9570)

### Graphics

Blacklist nvidia drivers. Put this in `/etc/modprobe.d/blacklist.conf`

```conf
blacklist nouveau
```
