FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .


FROM gcr.io/distroless/nodejs20-debian11
WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
CMD ["npm", "start"]
