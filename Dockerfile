FROM ubuntu
MAINTAINER enxajt

RUN apt-get update && apt-get install -y \
  language-pack-ja-base \
  language-pack-ja \
  ibus-mozc \
  fonts-ipafont-gothic \
  fonts-ipafont-mincho \
  curl \
  git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN alias curl='curl --noproxy localhost,127.0.0.1'
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
ENV LC_ALL C.UTF-8

# nodejs npm gulp
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  npm \
 && npm cache clean \
 && npm install n -g \
 && n stable \
 && ln -sf /usr/local/bin/node /usr/bin/node
RUN apt-get -y purge nodejs npm \
 && npm update \
 && npm install --global gulp gulp-cli

RUN apt-get install -y sudo

ENV USER enxajt
#RUN useradd -m -g sudo $USER && echo "$USER:$USER" | chpasswd
RUN useradd -m -g sudo $USER
USER $USER
WORKDIR /home/$USER

# gulp for impress 
RUN git clone https://github.com/$USER/gulp-impress.git /home/$USER/gulp-impress
WORKDIR /home/$USER/gulp-impress
RUN npm init -y \
 && npm install --save-dev gulp path gulp-webserver gulp-print gulp-cached gulp-exec gulp-ejs gulp-rename gulp-plumber gulp-json-transform gulp-tap gulp-replace
EXPOSE 8000 35729

RUN curl -L https://github.com/astefanutti/decktape/archive/v1.0.0.tar.gz | tar -xz --exclude phantomjs \
  && cd decktape-1.0.0 \
  && curl -L https://github.com/astefanutti/decktape/releases/download/v1.0.0/phantomjs-linux-x86-64 -o phantomjs \
  && chmod +x phantomjs

CMD ["/bin/bash"]
