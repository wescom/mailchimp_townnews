#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "wallowa"
ruby import_subscribers.rb wallowa

echo "$(date +%m/%d/%y\ %T)"
