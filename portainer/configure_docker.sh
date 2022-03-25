echo '{
    "hosts": ["unix:///var/run/docker.sock", "tcp://$INTERNALIP:2376"],
    "tls": true,
    "tlscacert": "/root/certs/ca.crt",
    "tlscert": "/root/certs/server.crt",
    "tlskey": "/root/certs/server.key",
    "tlsverify": true
}' > /etc/docker/daemon.json

echo '' > 