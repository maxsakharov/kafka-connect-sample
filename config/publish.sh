#!/bin/bash

if [[ -z "${KAFKA_CONNECT_HOST}" ]]; then
    echo "'KAFKA_CONNECT_HOST' environment variable should be defined";
fi;

if [[ -z "${CONNECTOR_NAME}" ]]; then
    echo "'CONNECTOR_NAME' environment variable should be defined";
fi;

STATUS_CODE=`curl -o /dev/null -s -w "%{http_code}\n" \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -X GET "${KAFKA_CONNECT_HOST}/connectors/${CONNECTOR_NAME}"`

echo "Connector check status code: ${STATUS_CODE}"

if [[ "${STATUS_CODE}" -eq "404" ]]; then
    echo "Creating new connector '${CONNECTOR_NAME}'";

    echo "curl -H 'Accept: application/json' \
         -H 'Content-Type: application/json' \
         -X POST '${KAFKA_CONNECT_HOST}/connectors' \
         -d '@config.json'"

    PUBLISHING_STATUS=`curl -o /tmp/curl-out -s -w "%{http_code}\n" \
         -H "Accept: application/json" \
         -H "Content-Type: application/json" \
         -X POST "${KAFKA_CONNECT_HOST}/connectors" \
         -d "@config.json"`

    echo "Status code: ${PUBLISHING_STATUS}"

    if [[ "${PUBLISHING_STATUS}" -ne "201" ]]; then
        echo "ERROR: Unsuccessful creation!!!";
        cat /tmp/curl-out
        exit 1
    else
         echo "Successfully created";
    fi;

else
    echo "Updating connector '${CONNECTOR_NAME}'";

    DATA=`cat config.json | jq -c '.config'`

    echo "curl -H 'Accept: application/json' \
         -H 'Content-Type: application/json' \
         -X PUT '${KAFKA_CONNECT_HOST}/connectors/${CONNECTOR_NAME}/config' \
         -d '${DATA}'"

    PUBLISHING_STATUS=`curl -o /tmp/curl-out -s -w "%{http_code}\n" \
         -H "Accept: application/json" \
         -H "Content-Type: application/json" \
         -X PUT "${KAFKA_CONNECT_HOST}/connectors/${CONNECTOR_NAME}/config" \
         -d "${DATA}"`

    echo "Status code: ${PUBLISHING_STATUS}"

    if [[ "${PUBLISHING_STATUS}" -ne "200" ]]; then
        echo "ERROR: Unsuccessful updated!!!";
        cat /tmp/curl-out
        exit 1
    else
         echo "Successfully updated";
    fi;
fi;