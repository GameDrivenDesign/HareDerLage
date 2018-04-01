FROM ubuntu:17.10

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties wget unzip

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libglew-dev freeglut3-dev libxi-dev libxmu-dev xserver-xorg-video-dummy xpra xorg-dev opencl-headers libgl1-mesa-dev libxcursor-dev libpulse-dev libxinerama-dev libxrandr-dev libxv-dev libasound2-dev libudev-dev mesa-utils libgl1-mesa-glx mesa-common-dev libglapi-mesa libgbm1 libgl1-mesa-dri libxatracker-dev xvfb

WORKDIR /home/developer/build

RUN wget -q --waitretry=1 --retry-connrefused -T 10 https://downloads.tuxfamily.org/godotengine/3.0.2/Godot_v3.0.2-stable_linux_server.64.zip -O /home/developer/godot.zip \
	&& unzip -q -d /home/developer /home/developer/godot.zip \
	&& mv /home/developer/Godot* /home/developer/build/godot

#RUN wget -q --waitretry=1 --retry-connrefused -T 10 https://downloads.tuxfamily.org/godotengine/3.0.2/Godot_v3.0.2-stable_export_templates.tpz -O /home/developer/export-templates.tpz \
RUN apt-get install -y gdb pulseaudio
COPY export-templates.tpz /home/developer/
RUN echo "download!" \
	&& mkdir -p /home/developer/data/godot/templates \
	&& unzip -q -d /home/developer/data/godot/templates /home/developer/export-templates.tpz \
	&& mv /home/developer/data/godot/templates/templates /home/developer/data/godot/templates/3.0.2.stable

COPY . .

#RUN export uid=1000 gid=1000 && \
#    mkdir -p /home/developer && \
#	mkdir -p /etc/sudoers.d && \
#    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
#    echo "developer:x:${uid}:" >> /etc/group && \
#    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#    chmod 0440 /etc/sudoers.d/developer && \
#    chown ${uid}:${gid} -R /home/developer && \
#    usermod -aG pulse,pulse-access developer

RUN export UNAME=developer UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R /home/${UNAME} && \
    gpasswd -a ${UNAME} audio

COPY pulse-client.conf /etc/pulse/client.conf

USER developer

ENTRYPOINT ["./entrypoint.sh"]
