FROM ubuntu:16.04
MAINTAINER krutpong "krutpong@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8

#add Thailand repo
RUN echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial main restricted" > /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-updates main restricted" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial universe" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-updates multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-security main restricted" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-security universe" >> /etc/apt/sources.list && \
    echo "deb http://mirror1.ku.ac.th/ubuntu/ xenial-security multiverse" >> /etc/apt/sources.list && \
    apt-get update

RUN apt-get install -y software-properties-common
RUN apt-get install -y python-software-properties
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update

#setup timezone
RUN apt-get install -y tzdata
RUN echo "Asia/Bangkok" > /etc/timezone \
    rm /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

#setup supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

#setup apache
RUN apt-get install -y apache2

RUN mkdir -p /var/lock/apache2 /var/run/apache2

COPY sites-available /etc/apache2/sites-available/

RUN sed -i 's/CustomLog/#CustomLog/' /etc/apache2/conf-available/other-vhosts-access-log.conf

#setup git
RUN apt-get install -y git

#setup nano
RUN apt-get install -y nano

#setup php
RUN apt-get install -y libapache2-mod-fastcgi
RUN apt-get install -y php-fpm
RUN apt-get install -y gcc
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y php-mysql
RUN apt-get install -y php-mcrypt
RUN apt-get install -y pwgen
RUN apt-get install -y php-bcmath
RUN apt-get install -y php-cli
RUN apt-get install -y php-curl
RUN apt-get install -y php-sqlite3
RUN apt-get install -y php-apcu
RUN apt-get install -y php-memcached
RUN apt-get install -y php-redis
RUN apt-get install -y php-dev
RUN apt-get install -y php-gd
RUN apt-get install -y php-pear
RUN apt-get install -y php-mongodb
RUN apt-get install -y php-mbstring
RUN apt-get install -y imagemagick
RUN apt-get install -y php-imagick
RUN apt-get install -y php-mcrypt
RUN apt-get install -y php-zip
RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y libreadline-dev
RUN apt-get install -y phpunit


#Pointing to php7.1-mcrypt with php7.2 will solve the issue here.
#Below are the steps to configure 7.1 version mcrypt with php7.2
RUN apt-get -y install gcc make autoconf libc-dev pkg-config
RUN apt-get -y install libmcrypt-dev
RUN pecl install mcrypt-1.0.1

RUN phpenmod mcrypt
RUN echo "extension=/usr/lib/php/20170718/mcrypt.so" > /etc/php/7.2/cli/conf.d/mcrypt.ini
RUN echo "extension=/usr/lib/php/20170718/mcrypt.so" > /etc/php/7.2/fpm/conf.d/mcrypt.ini


RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=AT/ST=Vienna/L=Vienna/O=Security/OU=Development/CN=example.com"

RUN a2enconf php7.2-fpm
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event alias
RUN a2enmod fastcgi proxy_fcgi
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers


RUN sed -i 's/^ServerSignature/#ServerSignature/g' /etc/apache2/conf-enabled/security.conf; \
    sed -i 's/^ServerTokens/#ServerTokens/g' /etc/apache2/conf-enabled/security.conf; \
    echo "ServerSignature Off" >> /etc/apache2/conf-enabled/security.conf; \
    echo "ServerTokens Prod" >> /etc/apache2/conf-enabled/security.conf;

# Install composer
RUN apt-get install -y zip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


RUN apt-get clean

EXPOSE 80
EXPOSE 443
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD config/index.html /var/www/index.html
ADD config/index.php /var/www/index.php
COPY config/apache2.conf /etc/apache2/apache2.conf

COPY config/apache_enable.sh apache_enable.sh
RUN chmod 744 apache_enable.sh


#VOLUME ["/var/lib/mysql"]
VOLUME ["/var/www","/var/www"]
RUN service php7.2-fpm start
CMD ["/usr/bin/supervisord"]








