#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "hermistonherald"
ruby import_subscribers.rb hermistonherald

echo "$(date +%m/%d/%y\ %T)"
