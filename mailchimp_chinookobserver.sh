#!/bin/bash
source /usr/local/rvm/environments/ruby-2.5.1@mailchimp

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "chinookobserver"
ruby import_subscribers.rb chinookobserver

echo "$(date +%m/%d/%y\ %T)"
