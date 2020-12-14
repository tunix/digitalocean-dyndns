FROM alpine
MAINTAINER Alper Kanat <me@alperkan.at>
RUN apk --no-cache add curl jq bash
COPY dyndns.sh /
USER nobody
ENTRYPOINT exec /dyndns.sh
