# bloomer/Dockerfile

FROM alpine
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vcs-url="${VCS_URL}" \
  maintainer="Neil Roza <neil@rtr.ai>"
WORKDIR /tmp
ADD configure-rosdep .
RUN set -euvx \
  && echo \
  && echo "apk update, install packages" \
  && apk --no-cache add \
    build-base \
    curl \
    expect \
    gettext \
    git \
    openssh-client \
    perl-xml-xpath \
    python \
    shadow \
  && echo \
  && echo "install git-lfs" \
  && curl -fsSLO https://github.com/git-lfs/git-lfs/releases/download/v2.6.1/git-lfs-linux-amd64-v2.6.1.tar.gz \
  && tar -vxzf git-lfs-linux-amd64-v2.6.1.tar.gz -C /usr/local/bin git-lfs \
  && command -v git-lfs \
  && echo \
  && echo "install pip" \
  && curl -fsSLo get-pip.py https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && echo \
  && echo "install git-lfs" \
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.python.sh | sh \
  && echo \
  && echo "install bloom" \
  && pip install bloom \
  && rosdep init \
  && echo \
  && echo "configure rosdep" \
  && ./configure-rosdep \
  && true
