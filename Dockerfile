FROM tiangolo/uwsgi-nginx-flask:python3.7

# If STATIC_INDEX is 1, serve / with /static/index.html directly (or the static URL configured)
ENV STATIC_INDEX 0
# ENV STATIC_INDEX 0
ENV STATIC_PATH /app/static
RUN echo " " > /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/debian jessie main" >> /etc/apt/sources.list  \
	&& echo "deb http://mirrors.aliyun.com/debian jessie-updates main" >> /etc/apt/sources.list
RUN git clone -b develop https://github.com/COMP3030JG3/hpvh_backend.git /tempapp \
	&& mv -f /tempapp/* /app 
RUN pip install -r /app/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple \
	&& git clone https://gitee.com/wsteth/hpvh_frontend.git /frontend 

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
	&& echo "deb https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_12.x jessie main" | tee /etc/apt/sources.list.d/nodesource.list \
	&& echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_12.x jessie main" | tee -a /etc/apt/sources.list.d/nodesource.list \
	&& apt-get update && apt-get install -y nodejs
RUN cd /frontend \
	&& npm config set registry http://registry.npm.taobao.org \
	&& npm install -g npm \
	&& npm i \
	&& npm run-script build \
	&& mv -f ./build/* /app/static \
	&& mv -f /app/static/static/css/ /app/static/ \
	&& cp -r /app/static/static/js/ /app/static/ 
COPY ./gzip.conf /etc/nginx/conf.d/gzip.conf