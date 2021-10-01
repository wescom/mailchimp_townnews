#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

ruby import_subscribers.rb bendbulletin
ruby import_subscribers.rb dailyastorian

echo "$(date +%m/%d/%y\ %T)"
