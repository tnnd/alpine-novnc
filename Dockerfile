FROM alpine:3.12

ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
        DISPLAY_WIDTH=1280 \
        DISPLAY_HEIGHT=720 \
	REMOTE_HOST=localhost \
	REMOTE_PORT=5900

RUN apk --update --upgrade add git bash supervisor fluxbox x11vnc xvfb xterm \
	&& cd /root/
	&& git clone https://github.com/tnnd/noVNC-alpine.git \
	&& rm -rf /root/noVNC/.git \
	&& apk del git

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8081

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
