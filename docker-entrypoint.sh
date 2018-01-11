#!/bin/sh

MANAGE_CMD="/webvirtmgr/manage.py"
DB_FILE="/data/webvirtmgr.sqlite3"

sed -i -e 's/127.0.0.1/0.0.0.0/g' /webvirtmgr/conf/gunicorn.conf.py

if [ "$1" == "webvirtmgr-console" ]; then
    exec /webvirtmgr/console/webvirtmgr-console
else
    if [ ! -f "$DB_FILE" ]; then
        [ -z $WEBVIRTMGR_ADMIN_USERNAME ] && echo "WEBVIRTMGR_ADMIN_USERNAME not supplied!" && exit 1
        [ -z $WEBVIRTMGR_ADMIN_EMAIL ] && echo "WEBVIRTMGR_ADMIN_EMAIL not supplied!" && exit 1
        [ -z $WEBVIRTMGR_ADMIN_PASSWORD ] && echo "WEBVIRTMGR_ADMIN_PASSWORD not supplied!" && exit 1

        $MANAGE_CMD syncdb --noinput || exit 1
        echo "
from django.contrib.auth.models import User;
User.objects.create_superuser('${WEBVIRTMGR_ADMIN_USERNAME}', '${WEBVIRTMGR_ADMIN_EMAIL}', '${WEBVIRTMGR_ADMIN_PASSWORD}')" | $MANAGE_CMD shell || exit 1
        echo "Superuser created successfully!"

        $MANAGE_CMD collectstatic --noinput || exit 1
        echo "webvirt preparations are done!"
    fi

    exec $@
fi