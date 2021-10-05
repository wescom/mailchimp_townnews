#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "chinookobserver"
ruby import_subscribers.rb chinookobserver

echo "$(date +%m/%d/%y\ %T)"
