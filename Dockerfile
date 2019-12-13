# bloomer/Dockerfile

FROM alpine
ENV ROSDISTRO_INDEX_URL="file:///etc/ros/index-v4.yaml"
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
COPY scrippies/install-git-lfs .
RUN set -euvx \
  && echo \
  && echo "apk update, install packages" \
  && apk --no-cache add \
    build-base \
    coreutils \
    curl \
    expect \
    gettext \
    git \
    openssh-client \
    perl-xml-xpath \
    python3 \
    shadow \
  && echo \
  && echo "install git-lfs" \
  && ./install-git-lfs \
  && command -v git-lfs \
  && echo \
  && echo "install pip" \
  && curl -fsSLO https://bootstrap.pypa.io/get-pip.py \
  && python3 get-pip.py \
  && echo \
  && echo "install bloom" \
  && pip install bloom \
  && echo \
  && echo "freeze rosdistro" \
  && mkdir -vp /etc/ros \
  && curl -fsSL https://github.com/ros/rosdistro/archive/master.tar.gz \
       | tar -C /etc/ros --strip-components 1 -xzf- \
  && sed -i s,https://raw.githubusercontent.com/ros/rosdistro/master,file:///etc/ros,g \
       /etc/ros/rosdep/sources.list.d/20-default.list \
  && echo \
  && echo "done"
