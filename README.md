# FortressCraft-Evolved-Docker-Server



## Usage

### Quick Start

To pull the image and 
```shell
sudo mkdir -p /opt/FCE
sudo docker run -d  \
    -p 27012:27012/udp  \
    -p 27020:27015/udp  \
    -v /opt/FCE:/FCE   \
    --name FCE   \
    --restart=always  \
    fce/image
```

Stop the server to make adjustments to `serveroverrides.ini` or `firstrun.ini` by running;

```shell
docker stop FCE
```

Afterwards start the image again:

```shell
docker start FCE
```
