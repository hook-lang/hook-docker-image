
#
# Hook Docker Image
#

FROM alpine:latest
 
LABEL maintainer="Fábio de Souza Villaça Medeiros <fabiosvm@outlook.com>"
LABEL description="Hook Docker Image"
LABEL version="0.1.0"

WORKDIR /usr/local

RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash git openssh cmake make gcc libc-dev linux-headers \
      sqlite-dev curl-dev hiredis-dev && \ 
    git clone https://github.com/fabiosvm/hook-lang.git hook-build && \
    cd ./hook-build && \
    ./scripts/build-and-install.sh && \
      "Release" "with-no-extensions" "/usr/local/hook" && \
    ./scripts/run-tests.sh && \
    rm -rf ./hook-build

ENV HOOK_HOME=/usr/local/hook
ENV PATH=$HOOK_HOME/bin:$PATH

CMD [ "hook", "-v" ]
