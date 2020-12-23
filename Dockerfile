FROM alpine:3.12
LABEL maintainer=thomas@thomashastings.com

ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	REMOTE_HOST=localhost \
	REMOTE_PORT=5900

RUN apk --update --upgrade add git bash supervisor nodejs nodejs-npm \
	&& git clone https://github.com/novnc/noVNC.git /root/noVNC \
	&& git clone https://github.com/novnc/websockify /root/noVNC/utils/websockify \
	&& cd /root/noVNC \
	&& git checkout v1.2.0 \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git \
	&& npm install npm@latest \
	&& npm install \
	&& ./utils/use_require.js --as commonjs --with-app \
	&& cp /root/noVNC/node_modules/requirejs/require.js /root/noVNC/build \
	&& sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh \
	&& apk del git nodejs-npm nodejs
	
COPY index.html /root/noVNC/build/index.html

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8081

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
