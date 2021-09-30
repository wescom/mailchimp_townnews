# Add account credentials and API keys here.
# See http://railsapps.github.com/rails-environment-variables.html
# This file should be listed in .gitignore to keep your settings secret!
# Each entry sets a local environment variable and overrides ENV variables in the Unix shell.
# For example, setting:
# GMAIL_USERNAME: Your_Gmail_Username
# makes 'Your_Gmail_Username' available as ENV["GMAIL_USERNAME"]
# Add application configuration variables here, as shown below.
#
# Main global settings
ENV['DAYS_PAST_TO_IMPORT'] = '1'   # number of past days to import from csv file (ie. 1 = yesterday, 2 = two days ago,...)
# MailChimp settings
ENV['MAILCHIMP_SUBSCRIPTION_GROUP_NAME'] = 'Subscriptions'
#
ENV['BULLETIN_LIST_ID'] = '7e54ad03a8'
ENV['REDMONDSPOKESMAN_LIST_ID'] = '3f18b6f620'
ENV['BAKERCITYHERALD_LIST_ID'] = ''
ENV['DAILYASTORIAN_LIST_ID'] = 'aa2bbf9c40'
ENV['BLUEMOUNTAINEAGLE_LIST_ID'] = ''
ENV['CAPITALPRESS_LIST_ID'] = '5d7644bd5d'
ENV['CHINOOKOBSERVER_LIST_ID'] = 'da88a38d49'
ENV['EASTOREGONIAN_LIST_ID'] = ''
ENV['HERMISTONHERALD_LIST_ID'] = ''
ENV['LAGRANDEOBSERVER_LIST_ID'] = ''
ENV['SEASIDESIGNAL_LIST_ID'] = ''
ENV['WALLOWA_LIST_ID'] = ''
# TownNews FTP settings and data configs
ENV['TOWNNEWS_REGISTERED_USERS_FILE'] = '/dailyuser/export/audience/userexport.csv'
ENV['TOWNNEWS_SUBSCRIBERS_FILE'] = '/dailyuser/export/audience/subscribers.csv'
ENV['TOWNNEWS_DIGITAL_SUBSCRIPTION_NAMES'] = 'Full Digital Access, The Bulletin Brainworks Free Service, Employee Access,The Redmond Spokesman Brainworks Service,The Astorian Brainworks Service'
ENV['TOWNNEWS_SUBSCRIPTION_NAMES'] = 'Full Digital Access, The Bulletin Brainworks Free Service, Employee Access,The Redmond Spokesman Brainworks Service,The Astorian Brainworks Service'
ENV['TOWNNEWS_REGISTERED_GROUP_NAME'] = 'Registered Account'
