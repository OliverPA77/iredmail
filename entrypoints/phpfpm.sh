#!/bin/bash
# Author: Zhang Huangbin <zhb@iredmail.org>

#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

. /docker/entrypoints/functions.sh

install -d -o ${SYS_USER_SYSLOG} -g ${SYS_GROUP_SYSLOG} -m 0755 /var/log/php-fpm
install -d -o ${SYS_USER_NGINX} -g ${SYS_GROUP_NGINX} -m 0755 /run/php

case "${SERVER_SIZE}" in
	'XS')
		FPM_MAXCHILDREN=10
		FPM_STARTSERVERS=2
		FPM_MINSPARESERVERS=1
		FPM_MAXSPARESERVERS=2
		;;
	'S')
		FPM_MAXCHILDREN=50
		FPM_STARTSERVERS=5
		FPM_MINSPARESERVERS=2
		FPM_MAXSPARESERVERS=5
		;;
	'M')
		FPM_MAXCHILDREN=200
		FPM_STARTSERVERS=10
		FPM_MINSPARESERVERS=5
		FPM_MAXSPARESERVERS=10
		;;
	'L')
		FPM_MAXCHILDREN=500
		FPM_STARTSERVERS=20
		FPM_MINSPARESERVERS=10
		FPM_MAXSPARESERVERS=20
		;;
	*)
		[ X"${FPM_MAXCHILDREN}" == X'' ] && FPM_MAXCHILDREN=200
		[ X"${FPM_STARTSERVERS}" == X'' ] && FPM_STARTSERVERS=10
		[ X"${FPM_MINSPARESERVERS}" == X'' ] && FPM_MINSPARESERVERS=5
		[ X"${FPM_MAXSPARESERVERS}" == X'' ] && FPM_MAXSPARESERVERS=10
		;;
esac
sed -i -E \
	-e "s/pm = .*/pm = dynamic/g" \
	-e "s/pm.max_children = .*/pm.max_children = ${FPM_MAXCHILDREN}/g" \
	-e "s/pm.start_servers = .*/pm.start_servers = ${FPM_STARTSERVERS}/g" \
	-e "s/pm.min_spare_servers = .*/pm.min_spare_servers = ${FPM_MINSPARESERVERS}/g" \
	-e "s/pm.max_spare_servers = .*/pm.max_spare_servers = ${FPM_MAXSPARESERVERS}/g" \
	/etc/php/*/fpm/pool.d/www.conf
