FROM ubuntu:20.04

ENV LANG=en_US.UTF-8
ENV TZ=Europe/Moscow

### time zone ###
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

### copy python requirements
COPY requirements.txt requirements.txt

### base ###
RUN apt-get update && apt-get -y upgrade && apt-get install -y docker-compose locales python3-pip sudo slirp4netns \
&& pip3 install --upgrade pip \
&& pip3 install jupyterlab --no-cache-dir \
&& pip3 install -r requirements.txt --no-cache-dir \
&& locale-gen en_US.UTF-8

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

ENV HOME=/home/gitpod
WORKDIR $HOME

### Gitpod user (2) ###
USER gitpod
