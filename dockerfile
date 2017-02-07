FROM debian:jessie

RUN apt-get update && apt-get -y upgrade

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install wget bzip2 libglib2.0-0 libnss3
RUN apt-get -y install libcups2
RUN apt-get -y install man-db
RUN apt-get -y install sudo 
RUN apt-get -y install xserver-xorg-core libxrender1 libxrandr2 libxcursor1 libfontconfig1 libxi6
RUN apt-get -y install pulseaudio libasound2 libasound2-plugins dbus
RUN apt-get -y clean
ADD start.sh /opt/start.sh

RUN mkdir -p /home/eagle && \
	echo "eagle:x:${uid:-1000}:gid=${gid:-1000}:eagle,,,:/home/eagle:/bin/bash" >> /etc/passwd && \
	echo "eagle:x:${uid:-1000}:" >> /etc/group && \
	echo "eagle ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/eagle && \
	chmod 0440 /etc/sudoers.d/eagle && \
	chown ${uid:-1000}:${gid:-1000} -R /home/eagle
	
WORKDIR /home/eagle
RUN wget -q -O Autodesk_EAGLE_8.0_English_Linux_64bit.tar.gz http://trial2.autodesk.com/NET17SWDLD/2017/EGLPRM/ESD/Autodesk_EAGLE_8.0_English_Linux_64bit.tar.gz
RUN tar -xf Autodesk_EAGLE_8.0_English_Linux_64bit.tar.gz -C /opt/
RUN rm Autodesk_EAGLE_8.0_English_Linux_64bit.tar.gz
RUN chown ${uid:-1000}:${gid:-1000} -R /opt/eagle-8.0.0
RUN chown ${uid:-1000}:${gid:-1000} /opt/start.sh
RUN chmod +x /opt/start.sh
USER eagle
RUN mkdir /home/eagle/eagle
ENV HOME /home/eagle

CMD /opt/start.sh
