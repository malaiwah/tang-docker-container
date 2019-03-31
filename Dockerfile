FROM alpine AS build

LABEL maintainer="Michel Belleau <michel.belleau@malaiwah.com>"

RUN apk add --no-cache git g++ musl musl-dev bash gawk gzip make tar gmp mpfr3 mpfr-dev mpc1 mpc1-dev isl isl-dev http-parser-dev autoconf automake gcc make meson ninja openssl-dev jansson-dev zlib-dev

RUN git clone https://github.com/latchset/jose.git && cd jose && meson build && cd build && ninja && ninja install

RUN git clone https://github.com/latchset/tang.git
COPY remove-systemd.patch /tang 
RUN cd tang && patch -p1 < remove-systemd.patch 
RUN cd tang && autoreconf -if  && ./configure && make && make install 

FROM alpine
COPY --from=build /usr/local/bin/jose /usr/local/bin/jose
COPY --from=build /usr/local/lib/libjose.so.0 /usr/local/lib/libjose.so.0
COPY --from=build /usr/local/lib/libjose.so.0.0.0 /usr/local/lib/libjose.so.0.0.0

COPY --from=build /usr/local/libexec/tangd /usr/local/libexec/tangd
COPY --from=build /usr/local/libexec/tangd-keygen /usr/local/libexec/tangd-keygen
COPY --from=build /usr/local/libexec/tangd-update /usr/local/libexec/tangd-update


RUN apk add --no-cache bash socat http-parser jansson zlib openssl
EXPOSE 80

COPY start.sh /
CMD ["/start.sh"]
