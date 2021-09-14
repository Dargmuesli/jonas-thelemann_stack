#!/bin/sh

set -e
set -u

username="$(cat /run/secrets/postgres_user)"

function create_database() {
    local database=$1
    echo "  Creating user and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$username" --dbname "postgres" <<-EOSQL
        CREATE DATABASE "$database";
EOSQL
}

if [ -n "$POSTGRES_ADDITIONAL_DBS" ]; then
    echo "Additional database creation requested: $POSTGRES_ADDITIONAL_DBS"

    for db in $(echo $POSTGRES_ADDITIONAL_DBS | tr ',' ' '); do
        create_database $db
    done

    echo "Multiple databases created"
fi
