#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "redmondspokesman"
ruby import_subscribers.rb redmondspokesman

echo "$(date +%m/%d/%y\ %T)"
