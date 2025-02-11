FROM alpine:3.21
RUN apk --no-cache add jq curl

ARG ARCH=x86_64

COPY speedtest-cli.json /root/.config/ookla/

# Download from: https://www.speedtest.net/apps/cli
# https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz
# https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-aarch64.tgz
RUN curl -Lo speedtest.tar.gz "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${ARCH}.tgz" && tar zxvf speedtest.tar.gz && mv speedtest /usr/local/bin

COPY test_speed.sh /

ENTRYPOINT ["/test_speed.sh"]
