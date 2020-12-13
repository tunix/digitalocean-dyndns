FROM alpine
MAINTAINER Alper Kanat <tunix@raptiye.org>
RUN apk --no-cache add curl jq bash
COPY dyndns.sh /
USER nobody
ENTRYPOINT exec /dyndns.sh
