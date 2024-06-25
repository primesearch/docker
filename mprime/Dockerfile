# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ARG DIR="mprime"
ARG FILE="p95v3019b20.linux64.tar.gz"

RUN apt-get update -y && apt-get install -y wget curl expect

WORKDIR ${DIR}

COPY MPrime.sh ./

# Downloading MPrime
ADD --checksum=sha256:4ce2377e03deb4cf189523136e26401ba08f67857a128e420dd030d00cdca601 https://www.mersenne.org/download/software/v30/30.19/${FILE} ./

# Decompressing the files
RUN tar -xzvf ${FILE}

# Setting up MPrime
ADD https://raw.github.com/tdulcet/Distributed-Computing-Scripts/master/mprime.exp ./

CMD ["bash", "MPrime.sh"]
