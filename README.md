# speedtest-graphite

This container runs the speedtest (by ookla) binary to get the download and upload speeds and sends some basic metrics to a graphite instance.

The script randomly chooses one of the 10 closest local servers

The script now supports InfluxDB 1.8+

## Environment variables

| Environment Variables  | Description | Default |
| ------------- | ------------- | ----- |
| `METRIC_PREFIX` | Prefix for the metric | `internet` |

### Graphite

| Environment Variables  | Description | Default |
| ------------- | ------------- | ----- |
| `GRAPHITE_ENABLE` | Enable Graphite | `true` |
| `GRAPHITE_HOST` | Graphite host | `localhost` |
| `GRAPHITE_PORT` | Graphite port | `2003` |


### INFLUXDB

| Environment Variables  | Description | Default |
| ------------- | ------------- | ----- |
| `GRAPHITE_ENABLE` | enable InfluxDB | `false` |
| `INFLUXDB_URL` | InfluxDB URL | `http://localhost:8086` |
| `INFLUXDB_ORG` | InfluxDB Org | `` |
| `INFLUXDB_BUCKET` | InfluxDB Bucket | `` |
| `INFLUXDB_TOKEN` | InfluxDB Token (either an API Token or `<user>:<password>`| `` |
