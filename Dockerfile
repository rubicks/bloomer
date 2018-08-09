# bloomer/Dockerfile

FROM alpine
WORKDIR /workdir
RUN set -euvx \
  && apk --no-cache add build-base curl expect gettext git python shadow \
  && curl -fsSLo get-pip.py https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && pip install bloom \
  && rosdep init
