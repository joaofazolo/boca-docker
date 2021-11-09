#!/bin/bash
#========================================================================
# Copyright 2020-2021 Joao Vitor Alves Fazolo and Rodrigo Laiola Guimaraes
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

boca-autojudge &
apache2 -DFOREGROUND
