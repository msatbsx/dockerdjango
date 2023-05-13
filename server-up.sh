#!/usr/bin/env bash
# start-up.sh

# Start Gunicorn processes & start the Nginx process and put it in the background
(gunicorn dockerdjango.wsgi --user www-data --bind 0.0.0.0:8010 --workers 3) &
nginx -g "daemon off;"

# more on gunicon https://docs.gunicorn.org/en/stable/deploy.html
# more on nginx in container https://docs.nginx.com/nginx-management-suite/nim/previous-versions/v1/tutorials/containers/