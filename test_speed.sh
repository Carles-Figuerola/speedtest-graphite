#!/bin/sh

# Verify inputs
GRAPHITE_ENABLE=${GRAPHITE_ENABLE:-true}
GRAPHITE_HOST=${GRAPHITE_HOST:-localhost}
GRAPHITE_PORT=${GRAPHITE_PORT:-2003}

INFLUXDB_ENABLE=${INFLUXDB_ENABLE:-false}
INFLUXDB_URL=${INFLUXDB_URL:-http://localhost:8086}
INFLUXDB_ORG=${INFLUXDB_ORG}
INFLUXDB_BUCKET=${INFLUXDB_BUCKET}
INFLUXDB_TOKEN=${INFLUXDB_TOKEN}
[[ -z "${INFLUXDB_ORG}" ]] && echo "Missing INFLUXDB_ORG" && exit 1
[[ -z "${INFLUXDB_BUCKET}" ]] && echo "Missing INFLUXDb_BUCKET" && exit 1
[[ -z "${INFLUXDB_TOKEN}" ]] && echo "Missing INFLUXDB_TOKEN" && exit 1

METRIC_PREFIX=${METRIC_PREFIX:-internet}

## Get speed test
TIME=`date +%s`
RESULT_FILE=$(mktemp "$(pwd)/result.XXXXXXXX")

echo "Starting Speedtest"
SERVER_ID=$(speedtest -L | grep -E '[0-9]{3,6}' | awk '{print $1}' | shuf -n 1)
timeout 300 speedtest -s ${SERVER_ID} --format=json | tee $RESULT_FILE

if [ ! -s "$RESULT_FILE" ]; then
  echo "File is empty"
  exit 1
fi

ping=$(cat $RESULT_FILE | jq .ping.latency)
download=$(cat $RESULT_FILE | jq .download.bandwidth)
upload=$(cat $RESULT_FILE | jq .upload.bandwidth)


if [[ "${GRAPHITE_ENABLE}" == "true" ]] ; then
  echo "Sending to $GRAPHITE_HOST:$GRAPHITE_PORT:"
  echo "$METRIC_PREFIX.ping $ping $TIME"
  echo "$METRIC_PREFIX.download $(( $download * 8 )) $TIME"
  echo "$METRIC_PREFIX.upload $(( $upload * 8 )) $TIME"

  echo "$METRIC_PREFIX.ping $ping $TIME" | nc -w5 $GRAPHITE_HOST $GRAPHITE_PORT
  echo "$METRIC_PREFIX.download $(( $download * 8 )) $TIME" | nc -w5 $GRAPHITE_HOST $GRAPHITE_PORT
  echo "$METRIC_PREFIX.upload $(( $upload * 8 )) $TIME" | nc -w5 $GRAPHITE_HOST $GRAPHITE_PORT
fi

if [[ "${INFLUXDB_ENABLE}" == "true" ]] ; then
  DATA="ping=${ping},download=${download},upload=${upload}"
  echo "Sending ${INFLUXDB_URL}/api/v2/write?bucket=${INFLUXDB_BUCKET}&org=${INFLUXDB_ORG}" -H "Authorization: Token REDACTED" --data-raw "${METRIC_PREFIX} ${DATA}"
  curl "${INFLUXDB_URL}/api/v2/write?bucket=${INFLUXDB_BUCKET}&org=${INFLUXDB_ORG}" -H "Authorization: Token ${INFLUXDB_TOKEN}" --data-raw "${METRIC_PREFIX} ${DATA}"
fi
