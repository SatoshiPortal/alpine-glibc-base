# Building the Base image for Alpine with glibc

```
docker build -t cyphernode/alpine-glibc-base:3.8 -f Dockerfile-x86_64 .
docker build -t cyphernode/alpine-glibc-base:3.8 -f Dockerfile-armhf .
docker build -t cyphernode/alpine-glibc-base:3.8 -f Dockerfile-aarch64 .
```
