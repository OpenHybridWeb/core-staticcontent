# To build docker image:
# docker build -t openhybridweb/core-staticcontent-controller .
#
# To run init-content.js
#
# docker run --rm -i -e "CONFIG_PATH=/app/data/static-content-config.yaml" -e "TARGET_DIR=/app/data/" -v "/tmp/contentdev/:/app/data/" -p 8080:8080 openhybridweb/core-staticcontent-controller node init-content.js
#
# To run server rest api:
#
# docker run --rm -i -e "DATA_DIR=/app/data/" -v "/tmp/contentdev/:/app/data/" -p 8080:8080 openhybridweb/core-staticcontent-controller
#
FROM node:14 AS stage1

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY *.js ./

EXPOSE 8080
CMD [ "node", "server.js" ]


# prod stage
FROM node:14-slim

COPY --from=stage1 /usr/src/app /usr/src/app

RUN apt-get update && apt-get install -y git curl && apt-get clean

WORKDIR /usr/src/app

EXPOSE 8080
CMD [ "node", "server.js" ]