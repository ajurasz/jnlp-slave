# Jenkins JNLP Slave 

This image is based on [jenkins/jnlp-slave](https://hub.docker.com/r/jenkins/jnlp-slave/) running alpine with docker binaries.

## Usage

To use Docker inside Docker we need to bind container's `/var/run/docker.sock` to host's `/var/run/docker.sock`.

```sh
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ajurasz/jnlp-slave:<tag> -url http://jenkins-server:port <secret> <agent name>
```

## Versions matrix

|  jnlp-slave  |   jdk   |   docker   |  gradle   |
|--------------|:-------:|:----------:|----------:|
|  latest / 1  |   11    | 18.06.2-ce |   5.6.2   |
