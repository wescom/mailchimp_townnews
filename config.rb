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
ENV['MAILCHIMP_MARKETING_GROUP_NAME'] = 'I still want to be the first to know about:'
ENV['MAILCHIMP_DEFAULT_NEWSLETTERS'] = "'From the Editors Desk'" #list of newsletters to default new members to. Do not include ' in names
#
ENV['BENDBULLETIN_LIST_ID'] = '7e54ad03a8'
ENV['REDMONDSPOKESMAN_LIST_ID'] = '3f18b6f620'
ENV['BAKERCITYHERALD_LIST_ID'] = 'cceb3fda23'
ENV['DAILYASTORIAN_LIST_ID'] = 'aa2bbf9c40'
ENV['BLUEMOUNTAINEAGLE_LIST_ID'] = 'a372fda86b'
ENV['CAPITALPRESS_LIST_ID'] = '5d7644bd5d'
ENV['CHINOOKOBSERVER_LIST_ID'] = 'da88a38d49'
ENV['EASTOREGONIAN_LIST_ID'] = '0a51a22157'
ENV['HERMISTONHERALD_LIST_ID'] = '7a6269ffd5'
ENV['LAGRANDEOBSERVER_LIST_ID'] = 'c3c558f605'
ENV['SEASIDESIGNAL_LIST_ID'] = '9c85cedaed'
ENV['WALLOWA_LIST_ID'] = '9586cf40b5'
# TownNews FTP settings and data configs
ENV['TOWNNEWS_REGISTERED_USERS_FILE'] = '/dailyuser/export/audience/userexport.csv'
ENV['TOWNNEWS_SUBSCRIBERS_FILE'] = '/dailyuser/export/audience/subscribers.csv'
ENV['TOWNNEWS_DIGITAL_SUBSCRIPTION_NAMES'] = 'Commercial Account Access,Full Digital Access, The Bulletin Brainworks Free Service, Employee Access,Wallowa County Chieftain Brainworks Service,Seaside Signal Brainworks Service,The Observer Brainworks Service,Hermiston Herald Brainworks Service,East Oregonian Brainworks Service,The Blue Mountain Eagle Brainworks Service,Baker City Herald Brainworks Service,Baker City Herald Brainworks Service - Free,The Redmond Spokesman Brainworks Service,The Astorian Brainworks Service,Chinook Observer Brainworks Service'
ENV['TOWNNEWS_SUBSCRIPTION_NAMES'] = 'Commercial Account Access,Full Digital Access, The Bulletin Brainworks Free Service, Employee Access,Wallowa County Chieftain Brainworks Service,Seaside Signal Brainworks Service,The Observer Brainworks Service,Hermiston Herald Brainworks Service,East Oregonian Brainworks Service,The Blue Mountain Eagle Brainworks Service,Baker City Herald Brainworks Service,Baker City Herald Brainworks Service - Free,The Redmond Spokesman Brainworks Service,The Astorian Brainworks Service,Chinook Observer Brainworks Service'
ENV['TOWNNEWS_SUBSCRIPTION_COMMERCIAL_PREFIX'] = 'Comm' #used to detertmine commercial subscription names without listing every single one
ENV['TOWNNEWS_REGISTERED_GROUP_NAME'] = 'Registered Account'
