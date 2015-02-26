FROM resin/rpi-raspbian:jessie
MAINTAINER Mats Johannesson <mats.johannesson@linuxkurser.nu>
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils apache2 libapache2-mod-php5 python-setuptools php5-ldap nano && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN easy_install supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./configs/index.html /var/www/html/index.html
ADD ./configs/bild.jpg /var/www/html/bild.jpg
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/log/supervisor/
CMD ["/bin/bash", "/start.sh"]
