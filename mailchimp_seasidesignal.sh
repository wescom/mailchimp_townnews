#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "seasidesignal"
ruby import_subscribers.rb seasidesignal

echo "$(date +%m/%d/%y\ %T)"
