FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

# Update system and install dependencies
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
