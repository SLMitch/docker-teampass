FROM php:7.1-apache

ENV TEAMPASS_VERSION 2.1.26-final-3

 # Install and configure missing PHP requirements
RUN docker-php-ext-configure bcmath  && docker-php-ext-install bcmath 
RUN  docker-php-ext-configure mysqli  && docker-php-ext-install mysqli

RUN apt-get update && \
  apt-get install -y libldap2-dev wget libpng-dev libmcrypt-dev && \
  docker-php-ext-configure ldap && docker-php-ext-install ldap && \
  docker-php-ext-configure gd  && docker-php-ext-install gd && \
  docker-php-ext-configure mcrypt  && docker-php-ext-install mcrypt && \
  apt-get remove -y libldap2-dev zlib1g-dev libpng-dev  libpng-dev libmcrypt-dev


RUN echo "max_execution_time = 120\nsessions.save_path = \"/tmp/\"\ndisplay_errors = On\nerror_reporting = E_NONE" >> /usr/local/etc/php/conf.d/docker-vars.ini

WORKDIR /var/www/html

RUN wget https://github.com/nilsteampassnet/TeamPass/archive/$TEAMPASS_VERSION.tar.gz -O - | tar -xz && \
  mv TeamP*/* . && \
  rm -rf TeamP*
RUN mkdir -p /etc/sk
RUN cp includes/libraries/csrfp/libs/csrfp.config.sample.php includes/libraries/csrfp/libs/csrfp.config.php
RUN chown -R www-data . /etc/sk
