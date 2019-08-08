
FROM oality/realestate:latest

RUN  rm -rf /plone/*.cfg /plone/bin /plone/parts /plone/src /plone/var /plone/.installed.cfg /plone/.mr.developer.cfg

COPY base.cfg sources.cfg prod.cfg versions.cfg /plone/

RUN buildDeps="dpkg-dev git gcc libbz2-dev libc6-dev libjpeg62-turbo-dev libopenjp2-7-dev libpcre3-dev libssl-dev libtiff5-dev libxml2-dev libxslt1-dev wget zlib1g-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && cd /plone \
 && buildout -c prod.cfg \
 && ln -s /data/filestorage/ /plone/var/filestorage \
 && ln -s /data/blobstorage /plone/var/blobstorage \
 && chown -R plone:plone /plone /data \
 && apt-get purge -y --auto-remove $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /plone/downloads/*

RUN sed -i -e 's/# fr_BE.UTF-8 UTF-8/fr_BE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=fr_BE.UTF-8

WORKDIR /plone/
