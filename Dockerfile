FROM alpine:3.4
MAINTAINER Joakim L Johansson <joakim.l.johansson@ericsson.com>

RUN apk --no-cache --update add build-base git curl bison flex-dev openssl-dev lksctp-tools-dev mksh \
  && git clone https://github.com/hamzasheikh/Seagull.git seagull \
  && ln -s /bin/mksh /bin/ksh \
  && cd seagull/seagull/trunk/src \
  && sed -e '/^BUILD_9/s/^/#/' -i build.conf \
  && sed '/-lfl/ d' -i build.conf \
  && sed '/^#ifdef/ d' -i library-crypto/auth.c \
  && sed '/^#endif/ d' -i library-crypto/auth.c \
  && ksh build.ksh -target clean \
  && ksh build.ksh -target all \
  && cp bin/* /usr/local/bin/ \
  && mkdir -p /opt/seagull \
  && cp generator-control/remote-ctrl.xml /opt/seagull/ \
  && cp -r exe-env/diameter-env /opt/seagull/diameter \
  && mkdir -p /opt/seagull/diameter/logs \
  && cd / \
  && rm -rf /seagull

EXPOSE 3868

CMD [ "seagull" ]


