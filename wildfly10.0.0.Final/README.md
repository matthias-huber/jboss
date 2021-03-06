[![](https://badge.imagelayers.io/inspectit/jboss:wildfly.svg)](https://imagelayers.io/?images=inspectit/jboss:wildfly 'Get your own badge on imagelayers.io')

# JBoss with inspectIT
JBoss Dockerfile including inspectIT

This docker image is based on the tutum/JBoss docker image including the inspectIT agent of the open source APM solution [www.inspectit.rocks](http://www.inspectit.rocks).
This image can be used easily as a replacement for the Wildfly image, meaning you only have to change your existing Dockerfile ```FROM xyz/jboss:wildfly``` to ```FROM inspectit/jboss:wildfly```.

## Quickstart
First you need a running inspectIT CMR. You can use our docker image:

```bash
$ docker run -d --name inspectIT-CMR -p 8182:8182 -p 9070:9070 inspectit/cmr
```

Now you can start a container with the following command:

```bash
$ docker run -d --link inspectIT-CMR:cmr -p 8080:8080 inspectit/wildfly:10.0.0.Final
```

## Configuration
### Agent name
By default, the inspectIT agent uses the hostname (docker-ID) as agent name. You can set a different name setting ```AGENT_NAME``` or hostname:

```bash
$ docker run -d --link inspectIT-CMR:cmr -p 8080:8080 -e AGENT_NAME=<agent-name> inspectit/wildfly:10.0.0.Final
```

```bash
$ docker run -d --link inspectIT-CMR:cmr -h <agent-name> -p 8080:8080 inspectit/wildfly:10.0.0.Final
```

### Using a custom inspectIT CMR
If you don't want to use the inspectIT CMR docker image or cannot link to it, you can set the IP address and port manually:

```bash
$ docker run -d -e INSPECTIT_CMR_ADDR=<cmr-ip-address> -e INSPECTIT_CMR_PORT=<cmr-port> -p 8080:8080 inspectit/wildfly:10.0.0.Final
```

## Specifying the Wildfly version
Currently, this image is based on the JBoss Wildfly 10.0.0.Final image. Support for different are also available.

## Specifying the inspectIT version
Currently, this image is based on the latest beta inspectIT release. Later, support for other versions is added.

## Build the docker image
If you want to build the JBoss/Wildlfy inspectIT image yourself, checkout this repository and run 

```bash
$ docker build -t inspectit/wildfly:10.0.0.Final .
```
