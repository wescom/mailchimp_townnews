#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "eastoregonian"
ruby import_subscribers.rb eastoregonian

echo "$(date +%m/%d/%y\ %T)"
