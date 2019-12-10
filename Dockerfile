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
ARG BUILD_CODE="default-build-code"
ENV \
    ROSDISTRO_INDEX_URL="file:///tmp/${BUILD_CODE}/rosdistro-master/index-v4.yaml" \
    ROSDEP_SOURCE_PATH="/tmp/${BUILD_CODE}/rosdistro-master/rosdep/sources.list.d"
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
  && echo "initialize rosdep" \
  && rosdep init \
  && echo \
  && echo "kill rosdep gbpdistro" \
  && find /etc/ros/rosdep -type f -name '*.list' -exec sed -i '/^gbpdistro /d' {} + \
  && echo \
  && echo "freeze rosdistro" \
  && curl -fsSL https://github.com/ros/rosdistro/archive/master.tar.gz | tar -xzf- \
  && sed -i s,https://raw.githubusercontent.com/ros/rosdistro/master/,file:///${PWD}/rosdistro-master/,g \
         rosdistro-master/rosdep/sources.list.d/20-default.list \
  && rm -rf /etc/ros/rosdep \
  && echo \
  && echo "rosdep update" \
  && rosdep update --verbose \
  && echo \
  && echo "done"
