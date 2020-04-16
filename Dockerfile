FROM alpine:edge

ARG asciidoctor_version=2.0.10
ARG asciidoctor_diagram_version=2.0.2
ARG asciidoctor_pdf_version=1.5.3
ARG asciidoctor_epub3_version=1.5.0.alpha.15
ARG asciidoctor_mathematical_version=0.3.1
ARG asciidoctor_interdoc_reftext=0.5.2

ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
  ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
  ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
  ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
  ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
  ASCIIDOCTOR_INTERDOC_REFTEXT_VERSION=${asciidoctor_interdoc_reftext} \
  JAVA_OPTS="-Djava.util.prefs.systemRoot=/java -Djava.util.prefs.userRoot=/java/.userPrefs"

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN mkdir -p /java

# Installing package required for the runtime of
# any of the asciidoctor-* functionnalities
RUN apk update && apk upgrade && apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    findutils \
    font-bakoma-ttf \
    graphviz \
    make \
    openjdk8-jre \
    py3-pip \
    py3-pillow \
    py-setuptools \
    python3 \
    ruby \
    ruby-mathematical \
    ttf-liberation \
    unzip \
    which \
    gnuplot \
    font-ipa@testing \
    wqy-zenhei@testing

# Installing Ruby Gems needed in the image
# including asciidoctor itself
RUN apk add --no-cache --virtual .rubymakedepends \
    build-base \
    libxml2-dev \
    ruby-dev \
  && gem install --no-document \
    asciidoctor:${ASCIIDOCTOR_VERSION} \
    asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION} \
    asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION} \
    asciidoctor-mathematical:${ASCIIDOCTOR_MATHEMATICAL_VERSION} \
    asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION} \
    asciidoctor-interdoc-reftext:${ASCIIDOCTOR_INTERDOC_REFTEXT_VERSION} \
    coderay \
    epubcheck \
    haml \
    kindlegen \
    pygments.rb \
    rake \
    rouge \
    slim \
    thread_safe \
    tilt \
    nokogiri \
    json \
  && apk del -r --no-cache .rubymakedepends

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN apk add --no-cache --virtual .pythonmakedepends \
    build-base \
    python3-dev \
  && pip3 install --no-cache-dir \
    actdiag \
    'blockdiag[pdf]' \
    nwdiag \
    Pygments \
    seqdiag \
  && apk del -r --no-cache .pythonmakedepends

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
