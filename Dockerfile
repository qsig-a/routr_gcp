FROM debian:buster-20190812


ENV LANG C.UTF-8
ARG ROUTR_VERSION=1.0.0-rc4
ARG GCSFUSE_REPO=gcsfuse-buster

RUN mkdir -p /opt/routr
RUN mkdir -p /opt/routr-conf
RUN mkdir -p /opt/gcs

WORKDIR /opt/routr

COPY routr-${ROUTR_VERSION}_linux-x64_bin.tar.gz .
COPY gcp-storage-acct.json /opt/gcs


RUN apt-get update \
    && apt-get install -y curl gnupg \
    && echo "deb http://packages.cloud.google.com/apt ${GCSFUSE_REPO}" main >> /etc/apt/sources.list.d/gcsfuse.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y netcat-openbsd \
    && apt-get install -y gcsfuse \
    && tar xvf routr-${ROUTR_VERSION}_linux-x64_bin.tar.gz \
    && mv routr-${ROUTR_VERSION}_linux-x64_bin/* . \
    && rm -rf routr-${ROUTR_VERSION}_linux-x64_bin.tar.gz \
       routr-${ROUTR_VERSION}_linux-x64_bin \
       routr.bat \
    && apt-get autoremove -y



EXPOSE 4567
EXPOSE 5060/udp
EXPOSE 5060
EXPOSE 5061
EXPOSE 5062
EXPOSE 5063

CMD ["./routr"]

ENTRYPOINT [ "gcsfuse --key-file /home/accts/gcp-storage-acct.json routr_config /home/routr" ]
