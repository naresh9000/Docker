version: '3.8'

services:
  web:
    image: nginx:latest
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M

  app:
    image: my-app:latest
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G

  db:
    image: postgres:latest
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
