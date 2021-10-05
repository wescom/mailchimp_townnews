#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "bendbulletin"
ruby import_subscribers.rb bendbulletin

echo "$(date +%m/%d/%y\ %T)"
