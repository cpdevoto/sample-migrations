#!/bin/bash
# wait-for-postgres.sh

## This file is used for two use cases at least:
## 1. developers.  There will not be an argument --deployment passed in.  This script will wait for postgres database to be ready, and will create two databases as the rake convention.  See config.yml
## 2. deployment.  There will be an argument --deployment passed in.  This script will therefore not wait for postgres since the postgres server will be ready, and will create only one database.  See config.yml

set -e

host="$1"
shift
cmd="$@"

if [ "$1" == '--deployment' ]; then
  >&2 echo 'This is deployment, therefore I will not wait for postgres availability.'
else
  until psql -h "$host" -U "postgres" -c '\l'; do
    >&2 echo "Postgres is unavailable - sleeping"
    sleep 1
  done
fi

>&2 echo "Postgres is up - executing migration"
if [ "$1" == '--deployment' ]; then
  >&2 echo "*** Creating the database for deployment ***"
  RAILS_ENV=deployment rake db:create --trace
  >&2 echo "*** Migrating the database for deployment ***"
  RAILS_ENV=deployment rake db:migrate --trace
else
  >&2 echo "*** Creating the database for developers ***"
  rake db:create --trace
  >&2 echo "*** Migrating the database for developers ***"
  rake db:migrate --trace
  rake db:migrate RAILS_ENV=test --trace
fi
