# Building the Base image for Alpine with glibc

```
docker build -t cyphernode/alpine-glibc-base:3.12.4 --build-arg ARCH=x86_64 .
docker build -t cyphernode/alpine-glibc-base:3.12.4 --build-arg ARCH=armhf .
docker build -t cyphernode/alpine-glibc-base:3.12.4 --build-arg ARCH=aarch64 .
```
