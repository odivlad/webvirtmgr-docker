FROM centos:7.4.1708

LABEL maintainer="Vladislav Odintsov <odivlad@gmail.com>"

RUN yum install -y \
    epel-release

RUN yum install -y \
    git \
    python-pip \
    libvirt-python \
    numpy \
    python-websockify

RUN mkdir /data/

RUN git clone https://github.com/retspen/webvirtmgr.git && \
    cd webvirtmgr && \
    git reset --hard v4.8.9 && \
    pip install -r requirements.txt && \
    ./manage.py collectstatic --noinput && \
    ln -s /data/webvirtmgr.sqlite3 /webvirtmgr/

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "/webvirtmgr/manage.py", "run_gunicorn", "-c", "/webvirtmgr/conf/gunicorn.conf.py" ]
