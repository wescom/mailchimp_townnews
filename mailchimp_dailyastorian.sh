#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "dailyastorian"
ruby import_subscribers.rb dailyastorian


echo "$(date +%m/%d/%y\ %T)"
