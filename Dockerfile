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
ARG BUILD_CODE="default-build-code"
WORKDIR /tmp/${BUILD_CODE}
ADD configure-rosdep .
ADD install-git-lfs .
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
  && ./install-git-lfs \
  && command -v git-lfs \
  && echo \
  && echo "install pip" \
  && curl -fsSLO https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && echo \
  && echo "install bloom" \
  && pip install bloom \
  && rosdep init \
  && echo \
  && echo "configure rosdep" \
  && ./configure-rosdep \
  && true
