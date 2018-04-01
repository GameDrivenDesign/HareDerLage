FROM ubuntu:17.10

WORKDIR /tmp/build

RUN apt-get update && apt-get install -y wget unzip
RUN wget -q --waitretry=1 --retry-connrefused -T 10 https://downloads.tuxfamily.org/godotengine/3.0.2/Godot_v3.0.2-stable_linux_server.64.zip -O /tmp/godot.zip \
	&& unzip -q -d /tmp /tmp/godot.zip \
	&& mv /tmp/Godot* /tmp/build/godot

#COPY export-templates.tpz /tmp/
#RUN echo "download!" \
RUN wget -q --waitretry=1 --retry-connrefused -T 10 https://downloads.tuxfamily.org/godotengine/3.0.2/Godot_v3.0.2-stable_export_templates.tpz -O /tmp/export-templates.tpz \
	&& mkdir -p /tmp/data/godot/templates \
	&& unzip -q -d /tmp/data/godot/templates /tmp/export-templates.tpz \
	&& mv /tmp/data/godot/templates/templates /tmp/data/godot/templates/3.0.2.stable

COPY . .

ENTRYPOINT ["./entrypoint.sh"]
