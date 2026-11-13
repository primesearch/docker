# syntax=docker/dockerfile:1
ARG TARGETARCH

FROM debian:13 AS mprime-amd64

ARG FILE="p95v3019b20.linux64.tar.gz"
ARG SUM="4ce2377e03deb4cf189523136e26401ba08f67857a128e420dd030d00cdca601"

FROM debian:13 AS mprime-386

ARG FILE="p95v3019b20.linux32.tar.gz"
ARG SUM="2b7e5d8447246cbb4fabebfd8599cee16a407e659b3bb5142314023e9f0d11e1"

FROM mprime-${TARGETARCH}

ARG DIR="mprime"

RUN apt-get update -y && apt-get install -y wget curl expect

WORKDIR ${DIR}

COPY MPrime.sh ./

# Downloading MPrime
ADD --checksum=sha256:${SUM} https://www.mersenne.org/download/software/v30/30.19/${FILE} ./

# Decompressing the files
RUN tar -xzvf ${FILE}

# Setting up MPrime
ADD https://raw.github.com/tdulcet/Distributed-Computing-Scripts/master/mprime.exp ./

CMD ["bash", "MPrime.sh"]
