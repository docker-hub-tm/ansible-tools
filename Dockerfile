FROM alpine:edge
LABEL maintainer="Tomonori Matsumura <matsumura_t@yahoo.co.jp>"

ENV PACKAGES="\
docker \
git \
openssh-client \
ruby \
docker-py \
libvirt \
rsync \
py3-bcrypt \
py3-certifi \
py3-cffi \
py3-chardet \
py3-colorama \
py3-cryptography \
py3-flake8 \
py3-idna \
py3-mccabe \
py3-netifaces \
py3-pbr \
py3-pexpect \
py3-pip \
py3-pluggy \
py3-psutil \
py3-ptyprocess \
py3-py \
py3-pycodestyle \
py3-pynacl \
py3-pytest \
py3-requests \
py3-ruamel \
py3-setuptools \
py3-urllib3 \
py3-virtualenv \
py3-websocket-client \
python3 \
"

ENV BUILD_DEPS="\
gcc \
libc-dev \
gdbm-dev \
libvirt-dev \
make \
ruby-dev \
ruby-rdoc \
"

ENV PIP_INSTALL_ARGS="\
--only-binary :all: \
--no-index \
-f /usr/src/molecule/dist \
"

ENV GEM_PACKAGES="\
rubocop \
json \
etc \
"

ENV MOLECULE_PLUGINS="\
molecule-azure \
molecule-containers \
molecule-docker \
molecule-digitalocean \
molecule-ec2 \
molecule-gce \
molecule-hetznercloud \
molecule-libvirt \
molecule-lxd \
molecule-openstack \
molecule-podman \
molecule-vagrant \
"

RUN \
    apk add --update --no-cache \
    ${BUILD_DEPS} ${PACKAGES} \
    && gem install ${GEM_PACKAGES} \
    && apk del --no-cache ${BUILD_DEPS} \
    && rm -rf /root/.cache
COPY --from=molecule-builder \
    /usr/src/molecule/dist \
    /usr/src/molecule/dist
RUN \
    python3 -m pip install \
    ${PIP_INSTALL_ARGS} \
    boto \
    boto3 \
    molecule[ansible] \
    ansible-lint \
    testinfra \
    ${MOLECULE_PLUGINS} && \
    molecule --version && \
    molecule drivers
# running molecule commands adds a minimal level fail-safe about build success

ENV SHELL /bin/bash
