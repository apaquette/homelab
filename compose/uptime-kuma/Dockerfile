FROM louislam/uptime-kuma:2

COPY caddy-local-ca.crt /usr/local/share/ca-certificates/caddy-local-ca.crt

RUN update-ca-certificates

ENV NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/caddy-local-ca.crt
