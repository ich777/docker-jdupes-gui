FROM ich777/debian-baseimage as builder

RUN apt-get update && \
	apt-get -y install --no-install-recommends git build-essential && \
	git clone https://github.com/jbruchon/jdupes.git /tmp/jdupes && \
	cd /tmp/jdupes && \
	sed -i "/PREFIX = \/usr\/local/c\PREFIX = \/usr" /tmp/jdupes/Makefile && \
	make -j$(nproc --all) && \
	DESTDIR=/tmp/out make install && \
	git clone https://github.com/Pesc0/jdupes-gui.git /tmp/jdupes-gui && \
	sed -i "/.*\s*Open file/, /)*btt_box.pack_start(self.openfile_btt, False, True, 0)/ s|^|#|" /tmp/jdupes-gui/jdupes-gui && \
	sed -i "/.*\s*Open containing folder/, /)*btt_box.pack_start(self.openfilexplorer_btt, False, True, 0)/ s|^|#|" /tmp/jdupes-gui/jdupes-gui && \
	sed -i "/.*\s*Move to trash/, /)*trash_btt.get_style_context().add_class(Gtk.STYLE_CLASS_SUGGESTED_ACTION)/ s|^|#|" /tmp/jdupes-gui/jdupes-gui && \
	sed -i '/dialog.add_action_widget(trash_btt, Gtk.ResponseType.OK)/ s/^#*/#/' /tmp/jdupes-gui/jdupes-gui && \
	cp /tmp/jdupes-gui/jdupes-gui /tmp/out/usr/bin/ && \
	chmod +x /tmp/out/usr/bin/*

FROM ich777/novnc-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-jdupes-gui"

RUN apt-get update && \
	apt-get -y install --no-install-recommends libgtk-3-0 python3-gi gir1.2-gtk-3.0 && \
	rm -rf /var/lib/apt/lists/* && \
	sed -i '/    document.title =/c\    document.title = "jdupes-Gui - noVNC";' /usr/share/novnc/app/ui.js && \
	rm /usr/share/novnc/app/images/icons/*

ENV DATA_DIR=/jdupes
ENV CUSTOM_RES_W=1280
ENV CUSTOM_RES_H=850
ENV CUSTOM_DEPTH=16
ENV NOVNC_PORT=8080
ENV RFB_PORT=5900
ENV TURBOVNC_PARAMS="-securitytypes none"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="jdupes"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048


ADD /scripts/ /opt/scripts/
COPY /icons/* /usr/share/novnc/app/images/icons/
COPY /conf/ /etc/.fluxbox/
COPY --from=builder /tmp/out /
RUN chmod -R 770 /opt/scripts/

EXPOSE 8080

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]