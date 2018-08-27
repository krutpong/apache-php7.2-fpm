# apache-php7.2-fpm SSL Self-Certificate

This repo is used apache2.4 with PHP version 7.2 on FastCGI service.

It can support share host you can see in folder sites-available then after run container apache will run command a2ensite * in sites-available.
I install the basic package like this.

#### Run Apache Open SSL Self-Certificate
```
docker run -d -p 80:80 -p 443:443
-v /hostpath/sites-available:/etc/apache2/sites-available/ 
krutpong/apache-php7.2-fpm
```

#setup git
git

#setup nano
nano

#setup php
libapache2-mod-fastcgi
php-fpm
gcc
libpcre3-dev
php-mysql
php-mcrypt
pwgen
php-cli
php-curl
php-sqlite3
php-apcu
php-memcached
php-redis
php-dev
php-gd
php-pear
php-mongodb
php-mbstring
imagemagick
php-imagick
php-mcrypt
