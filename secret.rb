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
# MailChimp API settings
ENV['MAILCHIMP_API'] = 'a75024ff27c2f570d066d747325f0dee-us3'
ENV['MAILCHIMP_SERVER'] = 'us3'
ENV['BULLETIN_LIST_ID'] = '7e54ad03a8'
ENV['SPOKESMAN_LIST_ID'] = '7e54ad03a8'
ENV['MAILCHIMP_SUBSCRIPTION_GROUP_NAME'] = 'Subscriptions'
# TownNews FTP settings
ENV['TOWNNEWS_REGISTERED_USERS_FILE'] = '/dailyuser/export/audience/userexport.csv'
ENV['TOWNNEWS_SUBSCRIBERS_FILE'] = '/dailyuser/export/audience/subscribers.csv'
ENV['TOWNNEWS_DIGITAL_SUBSCRIPTION_NAMES'] = 'Full Digital Access, The Bulletin Brainworks Free Service, Employee Access'
ENV['TOWNNEWS_SUBSCRIPTION_NAMES'] = 'Full Digital Access, The Bulletin Brainworks Free Service, Employee Access'
# TownNews FTP bendbulletin.com connection settings
ENV['TOWNNEWS_SERVER_DOMAIN_NAME'] = 'sftp.us-east-1.vip.tn-cloud.net'
ENV['TOWNNEWS_SERVER_FTP_LOGIN'] = 'bendfeeds'
ENV['TOWNNEWS_SERVER_FTP_PASSWORD'] = 'z6-h80JM'
