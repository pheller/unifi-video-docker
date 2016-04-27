FROM phusion/baseimage:0.9.17
MAINTAINER pheller@me.com

CMD ["/sbin/my_init"]

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y mongodb-server openjdk-7-jre-headless jsvc

RUN curl -o /tmp/unifi-video.deb \
    http://dl.ubnt.com/firmwares/unifi-video/3.2.2/unifi-video_3.2.2~Ubuntu14.04_amd64.deb \
  && dpkg -i /tmp/unifi-video.deb && rm /tmp/unifi-video.deb

RUN sed -i -e 's/^log/#log/' /etc/mongodb.conf \
  && echo "syslog = true" >> /etc/mongodb.conf

RUN mkdir /etc/service/mongo \
  && mkdir /etc/service/unifi-video

ADD run_mongo.sh /etc/service/mongo/run
ADD run_unifi.sh /etc/service/unifi-video/run

RUN chown root /etc/service/mongo/run \
  && chown root /etc/service/unifi-video/run \
  && chown -R mongodb:mongodb /var/lib/mongodb \
  && chown -R unifi-video:unifi-video /var/lib/unifi-video

VOLUME /var/lib/mongodb /var/lib/unifi-video
EXPOSE 22 6666 7080 7443 7445 7446 7447

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

