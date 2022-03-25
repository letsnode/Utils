#!/bin/bash

echo "-------------------------------------"
echo "-------Создаем SSL сертификаты-------"
echo "-------------------------------------"

CERT_LIFETIME=$1

function no_logs {
    $1 &> /dev/null
}

function create_key() {
    openssl genrsa -out $1.key 4096
}

function create_cert() {
    name=$1
    
    openssl req -new -x509 \
            -days $CERT_LIFETIME -key $name.key \
            -sha256 -out $name.crt \
            -subj "/CN=."
}

function sign_cert() {
    name=$1

    openssl req -sha256 -new \
            -key $name.key -out $name.csr \
            -subj "/CN=."

    openssl x509 -req -days $CERT_LIFETIME \
            -sha256 -in $name.csr \
            -CA ca.crt -CAkey ca.key \
            -CAcreateserial -out $name.crt
}

function create_ca_pair() {
    create_key ca
    create_cert ca
}

function create_server_pair() {
    create_key server
    create_cert server
    sign_cert server
}

function create_client_pair() {
    create_key client
    create_cert client
    sign_cert client
}

function cleanup() {
    rm *.srl *.csr
}

function run() {
    no_logs create_ca_pair
    no_logs create_server_pair
    no_logs create_client_pair
    cleanup
}

run

echo "-------------------------------------"
echo "---SSL сертификаты успешно созданы---"
echo "-------------------------------------"