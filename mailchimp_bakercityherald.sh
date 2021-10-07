#!/bin/bash
source /usr/local/rvm/environments/ruby-2.5.1@mailchimp

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "bakercityherald"
ruby import_subscribers.rb bakercityherald

echo "$(date +%m/%d/%y\ %T)"
