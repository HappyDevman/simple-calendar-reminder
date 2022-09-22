# Dockerfile

FROM ruby:3:0:1 AS calendar-development

ARG USER_ID
ARG BUNDLER_OPTS="--without development test"

USER root

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
      apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
                         libcurl4-openssl-dev libffi-dev imagemagick libmagickwand-dev wamerican libpq-dev tnef poppler-utils libreoffice && \
      curl -sL https://deb.nodesource.com/setup_10.x | bash && \
      apt-get install -y nodejs && \
      node -v && \
      apt-get remove -y ghostscript && \
      apt-get autoremove -y && \
      rm -rf /var/lib/apt/lists/* && \
      rm -rf /usr/share/man/man1

RUN curl -Ls https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs927/ghostscript-9.27.tar.gz -o ghostscript-9.27.tar.gz && \
    tar xvf ghostscript-9.27.tar.gz && \
    cd ghostscript-9.27 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf ghostscript-9.27.tar.gz ghostscript-9.27

COPY docker/imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

USER ${USER_ID}

RUN gem install bundler -v 1.17.3

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install --deployment ${BUNDLER_OPTS}
