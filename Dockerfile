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

ENV USER enxajt
#RUN useradd -m -g sudo $USER && echo "$USER:$USER" | chpasswd
RUN useradd -m -g sudo $USER
USER $USER
WORKDIR /home/$USER
RUN mkdir ~/.ssh
ADD id_rsa ~/.ssh/id_rsa
#RUN touch ~/.ssh/known_hosts \
#  && ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts \
#  && git clone git@bitbucket.org:enxajt/private-config.git \
#  && sh ./private-config/git.sh \
#  && sh ./private-config/user.sh

# gulp for impress 
RUN git clone https://github.com/$USER/gulp-impress.git /home/$USER/gulp-impress
WORKDIR /home/$USER/gulp-impress
RUN npm init -y \
 && npm install --save-dev gulp path gulp-webserver gulp-print gulp-cached gulp-exec gulp-ejs gulp-rename gulp-plumber gulp-json-transform gulp-tap
EXPOSE 8000 35729

CMD ["/bin/bash"]
