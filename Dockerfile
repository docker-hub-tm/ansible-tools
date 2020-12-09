FROM python:3.9-slim

# Install required packages
RUN apt-get update \
  && mkdir -p /usr/share/man/man1 \
  && apt-get install -y \
    apt ca-certificates curl git locales openssh-client sudo unzip

# Install Docker
RUN pip3 install --user docker

# Install Molecule
RUN pip3 install --user ansible \
                        boto \
                        boto3 \
                        molecule \
                        molecule-ec2
