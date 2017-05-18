#!/bin/bash

/usr/bin/ln -sf /dev/stderr /var/log/httpd/error_log

if [ $ALLOW_OVERRIDE == 'All' ]; then
    /usr/bin/sed -i 's/AllowOverride\ None/AllowOverride\ All/g' /etc/httpd/conf/httpd.conf
fi

if [ $LOG_LEVEL != 'warn' ]; then
    /usr/bin/sed -i "s/LogLevel\ warn/LogLevel\ ${LOG_LEVEL}/g" /etc/httpd/conf/httpd.conf
fi

/usr/bin/ln -sf /dev/stdout /var/log/httpd/access_log

# Set PHP timezone
/usr/bin/sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ ${DATE_TIMEZONE}/" /etc/php.ini

# Run Postfix
2>/dev/null /usr/sbin/postfix stop
/usr/sbin/postfix start

# Run Apache:
2>/dev/null /usr/sbin/apachectl -k stop
if [ $LOG_LEVEL == 'debug' ]; then
    /usr/sbin/apachectl -DFOREGROUND -k start -e debug
else
    &>/dev/null /usr/sbin/apachectl -DFOREGROUND -k start
fi