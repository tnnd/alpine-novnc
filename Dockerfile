FROM alpine:3.14

# Setup demo environment variables
ENV HOME=/root \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0 \
	DISPLAY_WIDTH=1280 \
	DISPLAY_HEIGHT=720

# Install git, supervisor, VNC, & X11 packages
RUN apk --update --upgrade add \
	bash \
	fluxbox \
	git \
	supervisor \
	x11vnc \
	xterm \
	xvfb

# Clone noVNC from github
RUN git clone https://github.com/tnnd/noVNC-alpine.git /root/noVNC \
	&& rm -rf /root/noVNC/.git \
	&& cp /root/noVNC/vnc.html /root/noVNC/index.html \
	&& mkdir /root/.vnc/ && x11vnc -storepasswd 1234 /root/.vnc/passwd \
	&& apk del git

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8081

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
