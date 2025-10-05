FROM node:16-alpine
WORKDIR /usr/src/app

# install deps first (faster, reproducible)
COPY package*.json ./
RUN npm ci --omit=dev || npm install --save

# copy source and start
COPY . .
EXPOSE 8080
CMD ["npm","start"]
