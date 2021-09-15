#!/usr/bin/env sh

echo "environment=${ENVIRONMENT}" >> /app/config.ini

if [ ! -z ${DB_HOST} ]; then
  sed -ie "s/dbhost=.*/dbhost=${DB_HOST}/i" /app/config.ini
fi

if [ ! -z ${DB_PORT} ]; then
  sed -ie "s/dbport=.*/dbport=${DB_HOST}/i" /app/config.ini
fi

echo "End entrypoint"
