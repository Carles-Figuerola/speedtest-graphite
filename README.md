# speedtest-graphite

This container runs the speedtest (by ookla) binary to get the download and upload speeds and sends some basic metrics to a graphite instance.

The script randomly chooses one of the 10 closest local servers

## Environment variables

| Environment Variables  | Description | Default |
| ------------- | ------------- | ----- |
| `GRAPHITE_HOST` | Graphite host | `localhost` |
| `GRAPHITE_PORT` | Graphite port | `2003` |
| `GRAPHITE_PREFIX` | Prefix for the graphite metrics | `internet` |
