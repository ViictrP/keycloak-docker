FROM quay.io/keycloak/keycloak:18.0.1 AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:18.0.1
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENV KEYCLOAK_ADMIN=$KEYCLOAK_ADMIN
ENV KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD
ENV KC_DB_USERNAME=$KC_DB_USERNAME
ENV KC_DB_PASSWORD=$KC_DB_PASSWORD
ENV KC_DB_URL_HOST=$KC_DB_URL_HOST
ENV KC_DB_URL_PORT=$KC_DB_URL_PORT
ENV KC_DB_SCHEMA=$KC_DB_SCHEMA
ENV KC_HOSTNAME=$HOSTNAME

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start --https-certificate-file=/opt/keycloak-17.0.0/tls/localhost.pem --https-certificate-key-file=/opt/keycloak-17.0.0/tls/localhost-key.pem --https-protocols=TLSv1.3,TLSv1.2 --hostname=keycloak.local:8443 --hostname-strict-backchannel=true"]
EXPOSE 8443
