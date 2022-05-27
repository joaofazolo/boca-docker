#!/bin/bash
#========================================================================
# Copyright Universidade Federal do Espirito Santo (Ufes)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# 
# This program is released under license GNU GPL v3+ license.
#
#========================================================================

until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -c '\q'; do
  >&2 echo "PostgreSQL server is unavailable - sleeping"
  sleep 1
done
  
>&2 echo "PostgreSQL server is up - executing command"

# https://stackoverflow.com/questions/14549270/check-if-database-exists-in-postgresql-using-shell
if PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
	# $? is 0
    echo "Database already exists"
else
    # ruh-roh
    # $? is 1
    echo "Create database"
    # https://stackoverflow.com/questions/5891888/piping-data-into-command-line-php
    cd /var/www/boca/src && echo "YES" | php private/createdb.php
fi

service php7.2-fpm start
apache2 -DFOREGROUND