FROM ghcr.io/gethomepage/homepage:latest

USER root

COPY caddy-local-ca.crt /app/caddy-local-ca.crt

ENV NODE_EXTRA_CA_CERTS=/app/caddy-local-ca.crt
