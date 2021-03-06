#!/bin/bash
export DISPLAY=:99
export XDG_RUNTIME_DIR=/tmp/xdg
export XAUTHORITY=${DATA_DIR}/.Xauthority

echo "---Checking for old display lock files---"
rm -rf /tmp/.X99*
rm -rf /tmp/.X11*
rm -rf ${DATA_DIR}/.vnc/*.log ${DATA_DIR}/.vnc/*.pid
chmod -R ${DATA_PERM} ${DATA_DIR}
if [ -f ${DATA_DIR}/.vnc/passwd ]; then
	if [ "${RUNASROOT}" == "true" ]; then
		chmod 600 /root/.vnc/passwd
	else
		chmod 600 ${DATA_DIR}/.vnc/passwd
	fi
fi
screen -wipe 2&>/dev/null

echo "---Resolution check---"
if [ -z "${CUSTOM_RES_W} ]; then
	CUSTOM_RES_W=1280
fi
if [ -z "${CUSTOM_RES_H} ]; then
	CUSTOM_RES_H=850
fi

if [ "${CUSTOM_RES_W}" -le 1279 ]; then
	echo "---Width to low must be a minimum of 1280 pixels, correcting to 1280...---"
    CUSTOM_RES_W=1280
fi
if [ "${CUSTOM_RES_H}" -le 849 ]; then
	echo "---Height to low must be a minimum of 850 pixels, correcting to 850...---"
    CUSTOM_RES_H=850
fi

echo "---Starting TurboVNC server---"
vncserver -geometry ${CUSTOM_RES_W}x${CUSTOM_RES_H} -depth ${CUSTOM_DEPTH} :99 -rfbport ${RFB_PORT} -noxstartup ${TURBOVNC_PARAMS} 2>/dev/null
sleep 2
echo "---Starting Fluxbox---"
screen -d -m env HOME=/etc /usr/bin/fluxbox
sleep 2
echo "---Starting noVNC server---"
websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem ${NOVNC_PORT} localhost:${RFB_PORT}
sleep 2

echo "---Starting jdupes-gui---"
cd ${DATA_DIR}
/usr/bin/jdupes-gui 2>/dev/null