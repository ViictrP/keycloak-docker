# Keycloak Docker
Dockerfile to run Keycloak

## Building the application
    docker build --tag keycloak-docker -f ./Dockerfile .

## Running the application

    docker run -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -e KC_DB=postgres -e KC_DB_USERNAME=postgres -e KC_DB_PASSWORD=postgres -e KC_DB_URL_HOST=url -e KC_DB_URL_PORT=5432 -e KC_DB_SCHEMA=sso_server keycloak-docker

To verify if the API is UP go to `http://localhost:8080`

