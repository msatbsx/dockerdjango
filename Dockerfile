FROM python:3.11.3-slim-bullseye

# install nginx
RUN apt-get update && apt-get install nginx vim -y --no-install-recommends
COPY nginx.site.conf /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# copy source and install dependencies
RUN mkdir -p /opt/app
RUN mkdir -p /opt/app/pip_cache
RUN mkdir -p /opt/app/dockerdjango
COPY requirements.txt server-up.sh /opt/app/
COPY .pip_cache /opt/app/pip_cache/
COPY dockerdjango /opt/app/dockerdjango/
COPY appsample /opt/app/appsample/
copy static /opt/app/static/
# not default django templates folder (setup in settings.py) 
copy templates /opt/app/templates/
WORKDIR /opt/app
RUN pip install -r requirements.txt --cache-dir /opt/app/pip_cache
RUN chown -R www-data:www-data /opt/app
RUN chmod 755 server-up.sh

# start server
EXPOSE 8020
STOPSIGNAL SIGTERM
CMD ["/opt/app/server-up.sh"]
