#!/usr/bin/env ruby

require "MailchimpMarketing"
require "digest"
require "./secret"
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
end

def member_exists_in_list?(client, list_id, member_data)
  response = client.lists.get_list_member(list_id, member_data["user_email"])
  return true

  rescue MailchimpMarketing::ApiError => e
    return false
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

##################################################################
### MAILCHIMP UPDATE functions
##################################################################
def merge_townnews_users_and_subscribers(townnews_users,townnews_subscribers)
  # merges registered users and subscriber into single array for importing to MailChimp
  townnews_users_and_subscribers = townnews_subscribers

  townnews_users.each do |user|
    #search townnews_users array for additional registered-only records
    user_in_subscriber_array = townnews_subscribers.find{|a| a['user_email'] == user['email']}
    if user_in_subscriber_array.nil?  # user was not a subscriber thus only registering, add to array
      townnews_users_and_subscribers.push(['','',user['last_name'],user['first_name'],'',user['email'],user['address'],'','',user['phone'],user['postal_code'],'','','Registered Account','','','','','','','','','','','','','','','','1','','',user['creationdate']])
    end
  end
  return townnews_users_and_subscribers
end

def subscriber?(member_data)
  # returns whether member is a subscriber
  if ENV['TOWNNEWS_SUBSCRIPTION_NAMES'].include? member_data["service_name"]
    return 'YES'
  else
    return 'NO'
  end
end

def digital_subscription?(member_data)
  # returns whether member has a digital subscription
  if ENV['TOWNNEWS_DIGITAL_SUBSCRIPTION_NAMES'].include? member_data["service_name"]
    return 'YES'
  else
    return 'NO'
  end
end

def update_member_subscription_group(client, list_id, member_data)
  # updates existing member's subscription group
  email = Digest::MD5.hexdigest member_data["user_email"].downcase
  if member_exists_in_list?(client, list_id, member_data)
    # create hash of interest_ids; set all to false except member's subscription group
    group_id = get_group_id_of_name(client, list_id, ENV['MAILCHIMP_SUBSCRIPTION_GROUP_NAME'])
    group_interests = client.lists.list_interest_category_interests(list_id, group_id) # find all interests of group_id
    interests_hash_to_set = {}
    keys_to_extract = ["id", "name"]
    group_interests["interests"].map do |interest|
      interests_hash_to_set[interest["id"]] = interest.has_value?(member_data["service_name"])
    end
    
    # update subscription group
    member = client.lists.update_list_member(
        list_id,
        member_data["user_email"],
        :interests => interests_hash_to_set
      )
      #puts member
  else
    puts "Member NOT FOUND in MailChimp"
  end
  
  rescue MailchimpMarketing::ApiError => e
    puts "GroupID Error: #{e}"  
end

def add_or_update_member_record(client, list_id, member_data)
  # set merge_fields to update in MailChimp member record
  merge_fields = {}
  merge_fields["FNAME"] = get_first_name(member_data)
  merge_fields["LNAME"] = get_last_name(member_data)

  merge_fields["PHONE"] = member_data["user_phone"] unless member_data["user_phone"].nil?
  merge_fields["FULL_ADDR"] = get_full_address(member_data) unless get_full_address(member_data).nil?
  merge_fields["ADDRESS"] = get_address(member_data) unless get_address(member_data).nil?
  merge_fields["CITY"] = get_city(member_data) unless get_city(member_data).nil?
  merge_fields["STATE"] = get_state(member_data) unless get_state(member_data).nil?
  merge_fields["ZIPCODE"] = get_zipcode(member_data) unless get_zipcode(member_data).nil?
  merge_fields["LASTSTART"] = member_data["startTime"] unless member_data["startTime"].nil?
  merge_fields["EXPIRE"] = member_data["expireTime"] unless member_data["expireTime"].nil?
  merge_fields["MMERGE18"] = member_data['disabled'] == "1" ? 'INACTIVE' : 'ACTIVE'
  merge_fields["MMERGE24"] = digital_subscription?(member_data)
  merge_fields["MMERGE25"] = subscriber?(member_data)

  #puts member_data.inspect
  #puts member_data["user_email"] + ' - ' + merge_fields["FNAME"] + ' ' + merge_fields["LNAME"]
  #puts "Status:  " + member_data['disabled'] + ' = ' + merge_fields["MMERGE18"]
  #puts "Digital? " + member_data["service_name"] + ' = ' + merge_fields["MMERGE24"]
  #puts "Sub?     " + member_data["service_name"] + ' = ' + merge_fields["MMERGE25"]
  #puts merge_fields
  
  # add or update MailChimp member record
  email = Digest::MD5.hexdigest member_data["user_email"].downcase
  if member_exists_in_list?(client, list_id, member_data)
    member = client.lists.update_list_member(
        list_id,
        member_data["user_email"],
        :status => "subscribed", # "subscribed","unsubscribed","cleaned","pending"
        :merge_fields => merge_fields
      )
  else
    member = client.lists.set_list_member(
        list_id,
        member_data["user_email"],
        {
          :email_address => member_data["user_email"],
          :status => "subscribed", # "subscribed","unsubscribed","cleaned","pending"
          :merge_fields => merge_fields
        }
      )
  end
  # update member's subsctiption group
  update_member_subscription_group(client, list_id, member_data)

  member = client.lists.get_list_member(ENV["BULLETIN_LIST_ID"], email)
  if merge_fields["MMERGE25"] == "YES"
    puts "Subscriber added/updated in MailChimp:  " + member['email_address'] + "  " + member['full_name']
  else
    puts "Registwered User added/updated in MailChimp:  " + member['email_address'] + "  " + member['full_name']
  end

rescue MailchimpMarketing::ApiError => e
  puts "Update Member Error: #{e}"
end

##################################################################
# MAIN
##################################################################
list_id = ENV["BULLETIN_LIST_ID"] # MailChimp audience list ID

# Get records from TownNews CSV files - registered users and subscribers
# TownNews files:
#   userexport.csv =  registered users in  TownNews database (subscribers and non-subscriber)
#   subscribers.csv = subsuscribers in TownNews database with their subscription info

download_TownNews_FTP_files()  #connect to TownNews FTP

# read downloaded records into arrays for import
townnews_users = get_townnews_users()               # returns array of registered users
townnews_subscribers = get_townnews_subscribers()   # returns array of subscribers

# merge registered users and subscribers into single array for import
townnews_users_and_subscribers = merge_townnews_users_and_subscribers(townnews_users,townnews_subscribers)

# Update MailChimp with new subscriber record changes
mailchimp_client = connect_mailchimp()  #connect to mailchimp API
townnews_users_and_subscribers.each do |member|
  add_or_update_member_record(mailchimp_client, list_id, member)
end


