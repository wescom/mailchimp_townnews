#!/bin/bash

echo "$(date +%m/%d/%y\ %T)"
cd /u/apps/mailchimp_townnews

echo "lagrandeobserver"
ruby import_subscribers.rb lagrandeobserver

echo "$(date +%m/%d/%y\ %T)"
