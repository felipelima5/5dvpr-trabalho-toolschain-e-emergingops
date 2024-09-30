FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./

USER root

RUN npm install

COPY . .

EXPOSE 80

CMD ["node","server.js"]
