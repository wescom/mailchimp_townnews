#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "capitalpress"
ruby import_subscribers.rb capitalpress

echo "$(date +%m/%d/%y\ %T)"
