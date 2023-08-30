#!/usr/bin/env ruby

require "MailchimpMarketing"
require "digest"
require "./secret"  # load secret parameter keys
require "./config"  # load config parameters
require "./get_townnews_csv_data.rb"

##################################################################
### CONNECT TO MAILCHIMP
##################################################################
def connect_mailchimp()
  client = MailchimpMarketing::Client.new()
  client.set_config({
    :api_key => ENV['MAILCHIMP_API'],
    :server => ENV['MAILCHIMP_SERVER']
  })
  result = client.ping.get()
  #puts result
  return client

  rescue MailchimpMarketing::ApiError => e
    puts "Connection Error: #{e}"
    exit!
end

##################################################################
### MAILCHIMP GROUP & INTEREST functions
##################################################################
def get_group_id_of_name(client, list_id, group_name)
  # searches through audience list for group name and returns id
  groups = client.lists.get_list_interest_categories(list_id)

  keys_to_extract = ["id", "title"]
  groups["categories"].map do |category|
    if category.has_value?(group_name)
      return category["id"]
    end
  end
  return nil
  
  rescue MailchimpMarketing::ApiError => e
    puts "GroupID Error: #{e}"  
    exit!
end

def get_interest_id_of_name(client, list_id, group_name, interest_name)
  # searches through group_name and returns group interest id

  # find group_id of group_name
  group_id = get_group_id_of_name(client, list_id, group_name)
  #puts group_id

  # find group_interest_id of interest_name
  group_interests = client.lists.list_interest_category_interests(list_id, group_id)
  keys_to_extract = ["id", "name"]
  group_interests["interests"].map do |interest|
    if interest.has_value?(interest_name)
      return interest["id"]
    end
  end
  return nil

  rescue MailchimpMarketing::ApiError => e
    puts "Group Interest Error: #{e}"  
    exit!
end

def member_exists_in_list?(client, list_id, member_data)
  response = client.lists.get_list_member(list_id, member_data["user_email"])
  return true

  rescue MailchimpMarketing::ApiError => e
    return false
    exit!
end

def add_group_interest(client, list_id, group_name, interest_name)
  # adds new interest to Mailchimp group, returns id

  # find group_id of group_name
  group_id = get_group_id_of_name(client, list_id, group_name)
  #puts group_id

  response = client.lists.create_interest_category_interest(
      list_id,
      group_id,
      { 'name' => interest_name }
    )
  puts "*** New mailchimp group_interest added: " + group_name + "->" + response['name']
  return response['id']

  rescue MailchimpMarketing::ApiError => e
    puts "Group Interest Add Error: #{e}"
    exit!
end

##################################################################
### NAME & ADDRESS funtions
##################################################################
def get_first_name(member_data)
  if member_data["user_firstname"].nil?
    if member_data["name"].nil?
      return ""
    else
      if member_data["name"].split.count > 1
        return member_data["name"].split.first
      else
        return member_data["name"]
      end
    end
  else
    return member_data["user_firstname"]
  end
end

def get_last_name(member_data)
  if member_data["user_lastname"].nil?
    if member_data["name"].nil?
      return ""
    else
      if member_data["name"].split.count > 1
        return member_data["name"].split.last
      else
        return member_data["name"]
      end
    end
  else
    return member_data["user_lastname"]
  end
end

def get_address(member_data)
  if !member_data["user_address"].nil?
    return member_data["user_address"].strip
  else
    if !member_data["postal_address"].nil?
      return member_data["postal_address"].strip
    else
      return ""
    end
  end
end

def get_city(member_data)
  if !member_data["user_municipality"].nil?
    return member_data["user_municipality"].strip
  else
    if !member_data["postal_city"].nil?
      return member_data["postal_city"].strip
    else
      return ""
    end
  end
end

def get_state(member_data)
  if !member_data["user_region"].nil?
    return member_data["user_region"].strip
  else
    if !member_data["postal_state"].nil?
      return member_data["postal_state"].strip
    else
      return ""
    end
  end
end

def get_zipcode(member_data)
  if !member_data["user_postcode"].nil?
    return member_data["user_postcode"].strip
  else
    if !member_data["postal_postcode"].nil?
      return member_data["postal_postcode"].strip
    else
      return ""
    end
  end
end

def get_full_address(member_data)
  # returns full address of member formatted properly
  full_addr = ""
  if member_data.key?("user_address")
    full_addr = get_address(member_data)
    full_addr = full_addr + "," unless get_address(member_data).empty?
  end
  if member_data.key?("user_municipality")
    full_addr = full_addr + " " + get_city(member_data) unless get_address(member_data).empty?
  end
  if member_data.key?("state")
    full_addr = full_addr + " " + get_state(member_data) unless get_address(member_data).empty?
  end
  if member_data.key?("zipcode")
    full_addr = full_addr + " " + get_zipcode(member_data) unless get_address(member_data).empty?
  end
  return full_addr.strip
end

def convert_date(current_date)
  #puts "************"
  #puts current_date

  if current_date.index("-") != nil
    current_date = current_date[/\d{4}-\d{1,2}-\d{1,2}/]
    new_date = Date.parse(current_date.strip).strftime("%m/%d/%Y")
    return new_date
  end
  if current_date.index("/") != nil
    current_date =  current_date[/\d{1,2}\/\d{1,2}\/\d{4}/]
    current_date = Date.strptime(current_date, '%m/%d/%Y').strftime("%Y-%m-%d")
    new_date = Date.parse(current_date.strip).strftime("%m/%d/%Y")
    return new_date
  end

  return ""
end

##################################################################
### MAILCHIMP UPDATE functions
##################################################################
def move_date_fields(client, list_id, member_data, index)

  #puts "     STARTDATE: " + convert_date(member_data["Last Start"]) unless member_data["Last Start"].nil?
  #puts "     EXPIREDATE: " + convert_date(member_data["Expire"]) unless member_data["Expire"].nil?
  #puts "     STOPDATE: " + convert_date(member_data["Last Stop"]) unless member_data["Last Stop"].nil?

  # set merge_fields to update in MailChimp member record
  merge_fields = {}
  merge_fields["STARTDATE"] = convert_date(member_data["Last Start"]) unless member_data["Last Start"].nil?
  merge_fields["EXPIREDATE"] = convert_date(member_data["Expire"]) unless member_data["Expire"].nil?
  merge_fields["STOPDATE"] = convert_date(member_data["Last Stop"]) unless member_data["Last Stop"].nil?

  member = client.lists.update_list_member(
      list_id,
      member_data["Email Address"],
      :merge_fields => merge_fields
    )
  puts "     Updated in MailChimp: "
  puts "                           " + member['merge_fields']['STARTDATE']
  puts "                           " + member['merge_fields']['EXPIREDATE']
  puts "                           " + member['merge_fields']['STOPDATE']
  
rescue MailchimpMarketing::ApiError => e
  puts "Update Member Error: #{e}"
end

##################################################################
# MAIN
##################################################################
# Get records from TownNews CSV files - registered users and subscribers
# TownNews files:
#   userexport.csv =  registered users in  TownNews database (subscribers and non-subscriber)
#   subscribers.csv = subscribers in TownNews database with their subscription info

# supplied parameter determines which site we will import from TownNews
if ARGV[0].nil?
  puts "No domain requested!"
  puts "   Please supply domain to import from TownNews"
  puts "   Example =   ./import_subscribers.rb bendbulletin"
  return
else
  domain = ARGV[0]
  puts "\n---------------------------------------------------------"
  puts "Domain to move: " + domain
  puts "---------------------------------------------------------\n"
end

#read current date data into array
subscriberfile = "./data/" + domain + "_dates.csv"
townnews_subscribers = CSV.parse(File.read(subscriberfile), headers: true)
puts "   Subscribers in file " + subscriberfile + " - " + townnews_subscribers.length.to_s

#connect to MailChimp
mailchimp_client = connect_mailchimp()  # connect to mailchimp API
list_id = ENV[domain.upcase+'_LIST_ID'] # get MailChimp audience list ID based on domain
list_name = mailchimp_client.lists.get_list(list_id)["name"] # get MailChimp audience name
puts "\nConnected to MailChimp audience: #" + list_id + " - " + list_name

#update each record within MailChimp with new dates
townnews_subscribers.each_with_index do |member,index|
  puts "#{index+1} - " + member['Email Address']
  move_date_fields(mailchimp_client, list_id, member, index)
end
