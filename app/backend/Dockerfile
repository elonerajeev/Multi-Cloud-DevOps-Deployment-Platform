# Dockerfile for backend for the applications

FROM node:20-alpine 

WORKDIR /app/backend

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5000

CMD ["node", "index.js"]
