FROM alpine:3.11.0

# Must be provided: x86_64, armhf or aarch64
ARG ARCH

ENV GLIBC_VERSION 2.29-r0
ENV GLIBC_FILE glibc-${GLIBC_VERSION}-${ARCH}.apk
ENV GLIBC_BIN_FILE glibc-bin-${GLIBC_VERSION}-${ARCH}.apk

RUN wget -O /etc/apk/keys/cyphernode@satoshiportal.com.rsa.pub https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/cyphernode@satoshiportal.com.rsa.pub \
 && wget "https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/SHA256SUMS.asc" \
 && wget "https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${GLIBC_FILE}" \
 && grep ${GLIBC_FILE} SHA256SUMS.asc | sha256sum -c - \
 && wget "https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${GLIBC_BIN_FILE}" \
 && grep ${GLIBC_BIN_FILE} SHA256SUMS.asc | sha256sum -c - \
 && apk add --update --no-cache ${GLIBC_BIN_FILE} ${GLIBC_FILE} \
 && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
 && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
 && rm -rf glibc.apk glibc-bin.apk
