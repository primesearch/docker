# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ARG DIR="mprime"
ARG FILE="p95v3019b15.linux64.tar.gz"

RUN apt-get update -y && apt-get install -y wget curl expect

WORKDIR ${DIR}

# Downloading Prime95
RUN wget https://www.mersenne.org/download/software/v30/30.19/${FILE}

# Decompressing the files
RUN tar -xzvf ${FILE}

# Setting up Prime95
RUN wget -nv https://raw.github.com/tdulcet/Distributed-Computing-Scripts/master/mprime.exp

CMD ["bash"]
