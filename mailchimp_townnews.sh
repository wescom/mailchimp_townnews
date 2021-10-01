#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

ruby import_subscribers.rb bendbulletin
ruby import_subscribers.rb redmondspokesman
ruby import_subscribers.rb dailyastorian
ruby import_subscribers.rb chinookobserver

echo "$(date +%m/%d/%y\ %T)"
