FROM php:7-apache

ENV TEAMPASS_VERSION 2.1.25.2

 # Install and configure missing PHP requirements
RUN docker-php-ext-configure bcmath  && docker-php-ext-install bcmath 
RUN apt-get update && \
  apt-get install -y libldap2-dev wget libpng-dev && \
  docker-php-ext-configure ldap && docker-php-ext-install ldap && \
  docker-php-ext-configure gd  && docker-php-ext-install gd && \
  apt-get remove -y libldap2-dev zlib1g-dev libpng-dev  libpng-dev


RUN echo "max_execution_time = 120" >> /usr/local/etc/php/conf.d/docker-vars.ini

WORKDIR /var/www/html

RUN wget https://github.com/nilsteampassnet/TeamPass/archive/$TEAMPASS_VERSION.tar.gz -O - | tar -xz && \
  mv TeamP*/* . && \
  rm -rf TeamP*
RUN mkdir -p /etc/sk
RUN chown -R www-data . /etc/sk
