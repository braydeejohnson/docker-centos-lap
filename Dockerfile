FROM centos:7
MAINTAINER Braydee Johnson <braydee@braydeejohnson.com>
LABEL Description="Linux, Apache 2.4, PHP 5.4, CentOS 7 - LAMP Stack" \
	License="Apache License 2.0" \
	Version="1.0"

RUN yum -y update && yum clean all
RUN yum -y install httpd && yum clean all
RUN yum -y install gcc php-pear php-devel make openssl-devel && yum clean all
RUN yum install -y \
	psmisc \
	httpd \
	postfix \
	php \
	php-bcmath \
	php-common \
	php-dba \
	php-gd \
	php-intl \
	php-ldap \
	php-mbstring \
	php-mysqlnd \
	php-odbc \
	php-pdo \
	php-pecl-memcache \
	php-pgsql \
	php-pspell \
	php-recode \
	php-snmp \
	php-soap \
	php-xml \
	php-xmlrpc \
	ImageMagick \
	ImageMagick-devel

RUN yum -y install cronie

RUN yum -y install epel-release -y
RUN yum -y update
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
RUN yum -y install ffmpeg ffmpeg-devel
RUN yum -y install mod_ssl openssl

RUN sh -c 'printf "\n" | pecl install mongo imagick'
RUN sh -c 'echo short_open_tag=On >> /etc/php.ini'
RUN sh -c 'echo extension=mongo.so >> /etc/php.ini'
RUN sh -c 'echo extension=imagick.so >> /etc/php.ini'

ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC

COPY run-lap.sh /usr/sbin/
COPY index.php /var/www/html/
RUN chmod +x /usr/sbin/run-lap.sh
RUN chown -R apache:apache /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH "/root/.composer/vendor/bin:$PATH"

VOLUME /var/www/html
VOLUME /var/log/httpd

EXPOSE 80

CMD ["/usr/sbin/run-lap.sh"]