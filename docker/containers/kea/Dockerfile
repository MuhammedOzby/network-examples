FROM --platform=linux/amd64 debian:12-slim AS debian-base
RUN apt-get update
RUN apt-get install kea -y
RUN chmod 777 /etc/kea/*
RUN mkdir /run/kea
RUN mkdir /var/lib/kea
RUN touch /var/lib/kea/kea-leases4.csv