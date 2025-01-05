# Troubleshooters

Statically compiled troubleshooting tools for Linux systems.

If you need to troubleshoot a Linux machine but you don't want to bring 
troubleshooting tools in such machine by Docker or because your machine is 
lacking a package manager with which install tools, this is what you may need.

## Why?

While reading [Brendan Gregg's System Performance: Enterprise and the Cloud](https://www.brendangregg.com/blog/2020-07-15/systems-performance-2nd-edition.html) 
I wondered: *what if I need to troubleshoot a Linux machine but I am unable to* 
*start a troubleshooting Docker image or install any useful tool in the machine?* 

I'd copy required tools by `scp` or similar in the machine but such tools 
should be compatible with machine system libraries: that's why, in different 
Docker containers, I compile troubleshooting tools in a compatible way for 
target machine.

## Environments

At the moment, troubleshooting tools are statically compiled in following distros:

- `Debian 12`;

- `Ubuntu 22.04`.

There is a `Dockerfile.<DISTRO>` for every Linux distro: each of it may have 
different package manager and system libraries versions.

`Dockerfile.compile` is used by every distro: it downloads troubleshooting packages 
source code and compile them, ready to be copied from the resulting container.

## Tools

- from `procps` package: `sysctl`, `vmstat`
- from `sysstat` package: `iostat`, `mpstat`, `pidstat`, `sar`

## Compilation

Just run `./build.sh` then `docker run` the Docker container from which you want 
to get tools for the target system you need.

```bash
$ ./build.sh
...

$ docker images                             
REPOSITORY            TAG            IMAGE ID       CREATED          SIZE
tshooters             ubuntu-22-04   61fd47899ff4   30 minutes ago   501MB
tshooters-build-env   ubuntu-22-04   269206f1815c   31 minutes ago   425MB
tshooters             debian-12      e028579974e4   32 minutes ago   620MB
tshooters-build-env   debian-12      083eae208fbf   33 minutes ago   551MB

# Say you want to get vmstat for Ubuntu 22.04
$ docker run -it --rm tshooters:ubuntu-22-04 bash
# Once inside, you may see that a statically compiled binary is bigger than a 
# few kilobytes, since it has everything it needs
root@c3be227cc0ec:/binaries$ ls -lah vmstat 
-rwxr-xr-x 1 root root 1.9M Jan  5 14:06 vmstat

# From another terminal, copy the binaries you need
$ docker cp c3be227cc0ec:/binaries/vmstat .
Successfully copied 1.91MB to .../tshooters/.
$  ./vmstat   
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 2  0      0 8453136 302980 4433540  0    0   883   742 2586    4  5  2 92  1  0  0
```

## TODO

- [ ] compile for more Linux distros:
  - [ ] Fedora
  - [ ] RHEL
- [ ] instead of manually copying required tools from containers, just zip them 
  and write them to host file system machine
- [ ] some automatic testing where binaries are run on virtualized target systems
      via Firecracker? QEMU? 