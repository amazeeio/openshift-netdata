Ported over from [fzerorubigd/netdata-docker](https://github.com/fzerorubigd/netdata-docker/) with a few adaptions.

# netdata Docker

A simple, fully configurable from env docker container for [netdata](https://github.com/firehol/netdata).

The goal was to configure `every` part of the config. also the base image is `alpine` and the result image is very small.

*TODO* : Proper documents

## How config work?

For change netdata configuration in ini files (like `netdata.conf` and `stream.conf`) via ENVs, use as below syntax:

```
-e ND_{ANYTHING}="file.conf|section/key=value"
```
for example to edit `update every` in `netdata.conf` and `global` section:

```
-e ND_1="netdata.conf|global/update every = 5"
```

And for change notification configs in `health_alarm_notify.conf`, use as below syntax:
```
-e ENV_{CONFIG_VARIABLE}={CONFIGURATION_VALUE}
```
for example to enable sending alerts via email:
```
-e ENV_SEND_SLACK="YES"
```

Done, Have a good monitoring :-)
