#!/bin/bash -ex

## Reader's Digest Provisioning: Base Edition

# This script will take a raw instance of Ubuntu 14.04 Trusty and turn it into
# LAMP stack suitable for developing this website.

# Default MySQL passwords to 'password'
#echo "mysql-server mysql-server/root_password password password" | debconf-set-selections
#echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections

# For PHP7 related packages
sudo add-apt-repository ppa:ondrej/php

apt-get update -y && apt-get upgrade -y

apt-get -y install nano \
	autoconf \
	bison \
	build-essential \
	libssl-dev \
	libyaml-dev \
	libreadline6-dev \
	zlib1g-dev \
	libncurses5-dev \
	libffi-dev \
	libgdbm3 \
	libgdbm-dev \
	apache2 \
	libapache2-mod-fastcgi \

# SetUp DB here just choose one MySql or MariaDB
apt-get -y install mysql-server \
	mysql-client \

#apt-get -y install mariadb-server \
#	mariadb-client \

####
# must be run manually
# @see https://dev.mysql.com/doc/refman/5.7/en/mysql-secure-installation.html
#
#sudo mysql_secure_installation



apt-get -y install php7.0 \
	php7.0-amqp \
	php7.0-fpm \
	php7.0-mysql \
	php7.0-bcmath \
	php7.0-bz2 \
	php7.0-cli \
	php7.0-curl \
	php7.0-gd \
	php7.0-json \
	php7.0-intl \
	php-pear \
	php7.0-imap \
	php7.0-imagick \
	php7.0-memcache \
	php7.0-memcached \
	php7.0-mcrypt \
	php7.0-mbstring \
	php-oauth \
	php7.0-opcache \
	php7.0-ps \
	php7.0-pspell \
	php7.0-readline \
	php7.0-recode \
	php7.0-redis \
	php7.0-snmp \
	php7.0-sqlite3 \
	php7.0-tidy \
	php7.0-xml \
	php7.0-xmlrpc \
	php7.0-xsl \
	php7.0-yaml \
	php7.0-zip \
	php-xdebug \
	#phpmyadmin \ ### Must be installed after the db is operational

# Find a newer version of nodejs in this repository
add-apt-repository -y ppa:chris-lea/node.js
apt-get -y install nodejs npm

# Install useful node packages
npm install -g jslint
npm install -g gulp
npm install -g brunch

# Install PHP / Apache configuration
#cp /vagrant/build/php-cli.ini /etc/php5/cli/php.ini && echo "installed /etc/php5/cli/php.ini"
#cp /vagrant/build/php-apache.ini /etc/php5/apache2/php.ini && echo "installed /etc/php5/cli/php.ini"

# Install useful PHP packages
pear config-set auto_discover 1

# Install sass, bourbon, neat
gem install sass bourbon neat

# Install a .bash_login in the vagrant user's home
#if [ -e /vagrant/vendor/bin ];then
#	tee /home/vagrant/.bash_login <<BSHLOGIN
# Setup path
#	export PATH=/vagrant/vendor/bin:${PATH}
#BSHLOGIN
#fi

# Install a php error logging for dev.rdnap
if [ -e /vagrant/conf/php_errors.conf ]; then
	cp /vagrant/conf/php_errors.conf /etc/apache2/conf-available/
	a2enconf php_errors.conf
fi

# Install to allow override on /var/www
if [ -e /vagrant/conf/allow-override.conf ]; then
	cp /vagrant/conf/allow-override.conf /etc/apache2/conf-available/
	a2enconf allow-override.conf
fi

# Enable mod_rewrite and mod_vhost alias
a2enmod rewrite
a2enmod vhost_alias
a2enmod actions fastcgi alias
systemctl restart apache2.service


chown -R vagrant:vagrant /home/vagrant

# Create a 'wordpress' user with password 'password'
#if [ ! -f /var/log/databasesetup ];
#then
#	echo "Initializing database"
#	tee /var/log/databasesetup <<XXX
#CREATE USER 'rdnap'@'localhost' IDENTIFIED BY 'password';
#CREATE DATABASE rdnap;
#GRANT ALL ON rdnap.* TO 'root'@'localhost';
#FLUSH PRIVILEGES;
#XXX
#	mysql -uroot -ppassword </var/log/databasesetup
#fi

# Remove default web root, allow vagrant user to create more
#rm -rf /var/www/html
#chown vagrant.vagrant /var/www

# Configure build environment
#echo "Configuring build environment in build/build.env"

#if [ -e /var/www/html ]; then
#	mv -f /var/www/html /var/www/html.default
#fi

# Create logs directory if it does not already exist
# Remember that tis is not actually part of the repo
# as per the iggy file
if [ ! -d /vagrant/logs ]; then
	mkdir /vagrant/logs
	chown vagrant:vagrant /vagrant/logs
fi

# Install a php info page w/ error logging for dev.rdnap
#if [ -e /vagrant/lib/i.php ]
#then
#	cp /vagrant/lib/i.php /vagrant/web/wp/
#fi

# Restart apache
service apache2 restart
