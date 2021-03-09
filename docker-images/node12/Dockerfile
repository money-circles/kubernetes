FROM node:12 as build
WORKDIR /app
COPY . /app

FROM caddy:alpine
COPY --from=build /app /app
COPY Caddyfile /etc/caddy/Caddyfile
RUN cat /etc/caddy/Caddyfile