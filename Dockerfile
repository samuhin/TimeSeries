ARG DISTR='ubuntu'
ARG DISTR_VER='20.04'

FROM ${DISTR}:${DISTR_VER}

ENV LANG=en_US.UTF-8
ENV TZ=Europe/Moscow

### time zone ###
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

### base ###
RUN apt-get update && apt-get -y upgrade && apt-get install -y docker-compose locales python3-pip sudo slirp4netns \
&& apt-get -y autoremove && apt-get clean \
&& locale-gen en_US.UTF-8

### copy python requirements ###
COPY requirements.txt requirements.txt

### python packages install ###
RUN pip3 install --upgrade pip --no-cache-dir  \
&& pip3 install -r requirements.txt --no-cache-dir

### clean ###
RUN rm -rf ~/*

COPY TimeSeries.ipynb TimeSeries.ipynb

CMD [ "jupyter-lab", \
"--ip", "0.0.0.0", "--allow-root",\
"--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser", "/" ]
