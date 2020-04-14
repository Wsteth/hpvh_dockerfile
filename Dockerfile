FROM tiangolo/uwsgi-nginx-flask:python3.7

# If STATIC_INDEX is 1, serve / with /static/index.html directly (or the static URL configured)
ENV STATIC_INDEX 0
# ENV STATIC_INDEX 0
ENV STATIC_PATH /app/frontend
RUN git clone -b develop https://github.com/COMP3030JG3/hpvh_backend.git /tempapp \
	&& cp -rf /tempapp /app \
	&& rm -rf /tempapp \
	&& git clone -b develop https://github.com/COMP3030JG3/hpvh_frontend.git /frontend \
	&& pip install -r /app/requirements.txt \
	&& apt-get install nodejs \
	&& cd /frontend \
	&& npm --registry https://registry.npm.taobao.org install \
	&& npm run-script build \
	&& cp -r ./build /app/frontend 
COPY ./gzip.conf /etc/nginx/conf.d/gzip.conf
