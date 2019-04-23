FROM alpine:edge

ENV ASCIIDOCTOR_VERSION=${asciidoctor_version}

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update

# Installing package required for the runtime of
# any of the asciidoctor-* functionnalities
RUN apk update && apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    findutils \
    font-bakoma-ttf \
    graphviz \
    make \
    openjdk8-jre \
    py2-pillow \
    py-setuptools \
    python2 \
    ruby \
    ruby-mathematical \
    ttf-liberation \
    unzip \
    which \
    font-ipa@testing \
    wqy-zenhei@testing

# Installing Ruby Gems needed in the image
# including asciidoctor itself
RUN apk add --no-cache --virtual .rubymakedepends \
    build-base \
    libxml2-dev \
    ruby-dev \
  && gem install --no-document \
    asciidoctor \
    asciidoctor-diagram \
    asciidoctor-mathematical \
    coderay \
    haml \
    pygments.rb \
    rake \
    rouge \
    slim \
    thread_safe \
    tilt \
    nokogiri \
  && apk del -r --no-cache .rubymakedepends

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN apk add --no-cache --virtual .pythonmakedepends \
    build-base \
    python2-dev \
    py2-pip \
  && pip install --no-cache-dir \
    actdiag \
    'blockdiag[pdf]' \
    nwdiag \
    Pygments \
    seqdiag \
  && apk del -r --no-cache .pythonmakedepends

RUN rm -rf /var/cache/apk/*

WORKDIR /documents
VOLUME /documents

ENTRYPOINT ["asciidoctor"]
CMD []
