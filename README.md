DockerHub image link: https://hub.docker.com/r/odivlad/webvirtmgr/

This image is based on centos 7.4 official image.

To run webvirtmgr you must specify admin user, admin email and admin password via environment variables `WEBVIRTMGR_ADMIN_USERNAME`, `WEBVIRTMGR_ADMIN_EMAIL` and `WEBVIRTMGR_ADMIN_PASSWORD`. You must do this only on first run to initialise database.

This image exposes 8000/tcp port for main application and 6080/tcp port for VNC console app. You should setup access to these ports accordingly to cmdline.
By default it executes main application. If you supply `webvirtmgr-console` as CMD, VNC proxy would be run.

### Main application

First run:

```
docker run -d --name webvirtmgr -v /path/to/db/:/data/ -e WEBVIRTMGR_ADMIN_USERNAME=admin -e WEBVIRTMGR_ADMIN_EMAIL=admin@local.domain -e WEBVIRTMGR_ADMIN_PASSWORD=password -p 8000:8000 odivlad/webvirtmgr
```

All other runs:

```
docker run -d --name webvirtmgr -v /path/to/db/:/data/ -p 8000:8000 odivlad/webvirtmgr
```

### VNC proxy

If you need VNC console, run additional container like this:

```
docker run -d --name webvirtmgr-console -v /path/to/db/:/data/ -p 6080:6080 odivlad/webvirtmgr webvirtmgr-console
```

Application logs are available via `docker logs <container_name>` command.

You are welcome to send patches and raise issues via github at https://github.com/odivlad/webvirtmgr-docker/