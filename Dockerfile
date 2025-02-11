FROM alpine:3.21
RUN apk --no-cache add jq curl

ARG VERSION=1.2.0

COPY speedtest-cli.json /root/.config/ookla/

# Download from: https://www.speedtest.net/apps/cli
# https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz
# https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-aarch64.tgz
RUN ARCH=$(uname -m) \
  && curl -Lo speedtest-${VERSION}-${ARCH}.tar.gz "https://install.speedtest.net/app/cli/ookla-speedtest-${VERSION}-linux-${ARCH}.tgz" \
  && tar zxvf speedtest-${VERSION}-${ARCH}.tar.gz \
  && mv speedtest /usr/local/bin

COPY test_speed.sh /

ENTRYPOINT ["/test_speed.sh"]
