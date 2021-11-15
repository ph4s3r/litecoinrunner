# since Feb 4 Litecoin 0.18.1 runs fine on alpine >= 3.13 https://github.com/litecoin-project/litecoin/issues/407
# why not use alpine?
FROM alpine:3.14.3
LABEL maintainer="Peter K <peter@karacsonyi.cx>"
# hardcoded SHA (I like it) // equals to gpg check sec-wise anyway
ENV SHA=ca50936299e2c5a66b954c266dcaaeef9e91b2f5307069b9894048acf3eb5751
ENV V=0.18.1
ENV GLIBC_VERSION=2.34-r0

RUN set -ex

RUN apk update \
        && apk --no-cache add curl

# since the executable is 
# ELF 64-bit LSB pie executable, x86-64, version 1 (GNU/Linux), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0
# this guy maintains alpine glibc packages github.com/sgerrand

# curl -fsSL: https://explainshell.com/explain?cmd=curl+-fsSL+example.org

RUN                curl -o /tmp/glibc-${GLIBC_VERSION}.apk     -fsSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
               	&& curl -o /tmp/glibc-bin-${GLIBC_VERSION}.apk -fsSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
								&& curl -o /etc/apk/keys/sgerrand.rsa.pub      -fsSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    						&& apk --no-cache add /tmp/glibc-${GLIBC_VERSION}.apk \
    						&& apk --no-cache add /tmp/glibc-bin-${GLIBC_VERSION}.apk 

# get litecoin
RUN curl -o /tmp/l.tar.gz -fsSL https://download.litecoin.org/litecoin-${V}/linux/litecoin-${V}-x86_64-linux-gnu.tar.gz

# terminate build if our hardcoded SHA does not match the downloaded tar`s
# I messed up something with sha256sum --check, so just picked something else quickly
RUN if [ "$SHA" == "$(sha256sum /tmp/l.tar.gz | awk '{print $1}')" ]; then echo "SHA OK"; else echo "SHA mismatch, exiting" && exit 1; fi

RUN tar -zxvf /tmp/l.tar.gz -C /opt/

# some cleanup
RUN rm -f /tmp/lc_binary.tar.gz

RUN rm -rf /tmp/glibc-${GLIBC_VERSION}.apk \
    && rm -rf /tmp/glibc-bin-${GLIBC_VERSION}.apk

RUN apk del curl

#VOLUME ["/home/litecoin/.litecoin"]

# runas normal user
RUN adduser -D litecoin
USER litecoin

EXPOSE 9333

CMD /opt/litecoin-0.18.1/bin/litecoind -regtest -printtoconsole -disablewallet
