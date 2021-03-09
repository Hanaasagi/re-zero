### Proxychains config (for vagrant guest machine)

Copy the file to `/etc/proxychains.conf`.

Unless specified otherwise in Vagrantfile, the IP address of the host from the perspective of the guest is: `10.0.2.2`.


```
$ route -A inet | grep default
default         10.0.2.2        0.0.0.0         UG    0      0        0 eth0
```
