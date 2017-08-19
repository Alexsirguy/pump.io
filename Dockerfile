FROM alpine:3.5
LABEL maintainer Jan Koppe <post@jankoppe.de>

ARG PUMPIO__GUID=888
ARG PUMPIO__UID=888

ENV PUMP_LOCATION="/usr/local/lib/pumpio"
ENV PUMP_DATADIR="/var/local/pump.io"

COPY . "${PUMP_LOCATION}"

RUN apk add --no-cache graphicsmagick openssl nodejs python make g++ git \
     && cd "${PUMP_LOCATION}" \
     && npm install \
     && npm run build \
     && cd node_modules/databank \
     && npm install databank-mongodb \
     && addgroup -S -g "${PUMPIO__GUID}" "pumpio" \
     && adduser -S -D -H -G "pumpio" -h "${PUMP_LOCATION}" -u "${PUMPIO__UID}" "pumpio" \
     && mkdir -p /usr/local/bin "${PUMP_DATADIR}" \
     && chown "pumpio:pumpio" "${PUMP_DATADIR}" -R \
     && ln -s "${PUMP_LOCATION}/bin/pump" /usr/local/bin/pump \
     && apk del python make g++ git

WORKDIR "${PUMP_LOCATION}"
EXPOSE 31337
USER pumpio
CMD ["pump"]
