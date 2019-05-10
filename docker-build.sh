#!/bin/sh

# Must be logged to docker hub:
# docker login -u cyphernode

# Must enable experimental cli features
# "experimental": "enabled" in ~/.docker/config.json

image() {
  local arch=$1
  local arch2=$2

  echo "Building and pushing cyphernode/alpine-glibc-base for $arch tagging as ${version} alpine arch ${arch2}..."

  docker build -t cyphernode/alpine-glibc-base:${arch}-${version} --build-arg ARCH=${arch2} . \
  && docker push cyphernode/alpine-glibc-base:${arch}-${version}

  return $?
}

manifest() {
  echo "Creating and pushing manifest for cyphernode/alpine-glibc-base for version ${version}..."

  docker manifest create cyphernode/alpine-glibc-base:${version} \
                         cyphernode/alpine-glibc-base:amd64-${version} \
                         cyphernode/alpine-glibc-base:arm32v6-${version} \
                         cyphernode/alpine-glibc-base:aarch64-${version} \
  && docker manifest annotate cyphernode/alpine-glibc-base:${version} cyphernode/alpine-glibc-base:arm32v6-${version} --os linux --arch arm \
  && docker manifest annotate cyphernode/alpine-glibc-base:${version} cyphernode/alpine-glibc-base:amd64-${version} --os linux --arch amd64 \
  && docker manifest annotate cyphernode/alpine-glibc-base:${version} cyphernode/alpine-glibc-base:aarch64-${version} --os linux --arch arm64 \
  && docker manifest push -p cyphernode/alpine-glibc-base:${version}

  return $?
}

x86_docker="amd64"
x86_alpine="x86_64"
arm_docker="arm32v6"
arm_alpine="armhf"
aarch64_docker="arm64"
aarch64_alpine="aarch64"

#arch_docker=${arm_docker} ; arch_alpine=${arm_alpine}
#arch_docker=${aarch64_docker} ; arch_alpine=${aarch64_alpine}
arch_docker=${x86_docker} ; arch_alpine=${x86_alpine}

version="3.8"

echo "arch_docker=$arch_docker, arch_alpine=$arch_alpine"

image ${arch_docker} ${arch_alpine}

[ $? -ne 0 ] && echo "Error" && exit 1

[ "${arch_docker}" = "${x86_docker}" ] && echo "Built and pushed amd64 only" && exit 0
[ "${arch_docker}" = "${aarch64_docker}" ] && echo "Built and pushed aarch64 only" && exit 0

manifest

[ $? -ne 0 ] && echo "Error" && exit 1
