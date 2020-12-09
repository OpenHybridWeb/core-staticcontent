# core-staticcontent
Core component for managing and serving static content

## Configuration

The configuration yaml file defines components.

```yaml
components:
  - dir: jbossorg     # desired dir
    kind: git         # kind of component.
    spec:
      # git url
      url: https://github.com/jbossorg/jbossorg.github.io.git     
      ref: master  # branch
      dir: /       # subdirectory within repo
  - dir: jbossorg-css
    kind: git
    spec:
      url: https://github.com/jbossorg/jbossorg.github.io.git
      ref: master
      dir: /css/
  - dir: jbossorg-js
    kind: git
    spec:
      url: https://github.com/jbossorg/jbossorg.github.io.git
      ref: master
      dir: /js/
```

## Modules 

Consists of two modules:

### Init

responsible for initialization of the storage
Used as init container.

```shell script
export CONFIG_PATH=/full/path/to/config.yaml
export TARGET_DIR=/full/target/path
node init-content.js 
```

The result is that all git repose are cloned based on configurations

### REST API

Rest API for incremental updates.
Used as side containers.

```shell script
export DATA_DIR=/full/target/path
node server.js
```

API:

1. `/_staticcontent/api/update/:dir` - performs git pull on given dir


## How to run

### Docker

Use docker from [Docker Hub](https://hub.docker.com/r/openhybridweb/core-staticcontent) or build your own.

Build image:

```shell script
docker build -t openhybridweb/core-staticcontent-controller .
```

Prepare config for docker
```shell script
mkdir /tmp/contentdev
cp examples/static-content-config.yaml /tmp/contentdev/static-content-config.yaml
```

Run init:

```shell script
docker run --rm -i -e "CONFIG_PATH=/app/data/static-content-config.yaml" -e "TARGET_DIR=/app/data/" -v "/tmp/contentdev/:/app/data/" -p 8080:8080 openhybridweb/core-staticcontent-controller node init-content.js
```

Run REST API:

```shell script
docker run --rm -i -e "DATA_DIR=/app/data/" -v "/tmp/contentdev/:/app/data/" -p 8080:8080 openhybridweb/core-staticcontent-controller
```

### Minikube

```shell script
minikube start
```

```shell script
kubectl create secret generic core-staticcontent-config --from-file=examples/static-content-config.yaml
kubectl apply -f examples/k8s/core-staticcontent.yaml
```

To check expose the service and target file

```shell script
minikube service core-staticcontent
```
