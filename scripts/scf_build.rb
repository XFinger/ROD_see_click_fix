# scf_build.rb
# initial build - if this is the initial build of the see click fix db, set @initial build to true. This
# will fix the time stamps to give us a more acurate timeline of events
# see_click_new checks for new records, adds them to the db and puts them into an array for uploading to Socrata
# see_click_update checks all non-archived records for changes to their status, updates the db, and puts them into
# an array for uploading to Socrata.
# Export pushes all of the new & updated records up to Socrata.

require 'net/https'
require 'hashie'
require 'rubygems'
require 'json'
require 'soda/client'
require 'configatron'      #configatron for private usernames, passwords ...'
require 'date'
require 'sinatra/activerecord'
require 'open-uri'
require 'sqlite3'
require 'httparty'
require_relative 'logger.rb'
require_relative '../lib/defaults.rb'

DB=ActiveRecord::Base.establish_connection(
 :adapter  => 'sqlite3',
 :database => 'seeCF2.db'
)
ActiveRecord::Base.record_timestamps = false #turn off active record automatically setting timestamps
class Issue < ActiveRecord::Base 
 DATE_FORMAT = '%m/%d/%Y'               
 def initialize 
   @client = SODA::Client.new({
     :domain => 'data.raleighnc.gov',
     :app_token => configatron.app_token,
     :username => configatron.client_username,
     :password => configatron.client_pass,
     :content_type => 'text/plain',
     :mime_type => 'JSON',
     :ignore_ssl => true 
     })  
   @view_id = 'xxx-xxx' 
   @payload=[] 
   
   @count=0
 #  @initial_build = true #set to true to set up timestamps after initially creating the database
                          #set to false to skip this step

 end
 
# def initial_build #set timestamps if initial build is true
#  if @initial_build == true
#   @issues = Issue.all
#   @issues.each do |fix|
#    
#     
#    #fix.created_at = Date.parse(fix.created_at.to_date).strptime("%m/%d/%Y")
#    fix.updated_at = Date.parse(fix.updated_at).strftime("%m/%d/%Y")
#     
#    case fix.status
#      when  'Acknowledged'
#        fix.acknowledged_at = fix.updated_at
#      when 'Closed'
#        fix.closed_at = fix.updated_at
#      when  'Archived'
#        fix.archived_at = fix.updated_at
#      else
#     end
#     fix.save!
#     end
#    end
#    puts @tcount.to_s + 'non working'
#    see_click_new
#   end
 
 def see_click_new    #get all new issues from see click fix
     @update_date = Date.today - 3
     @results=HTTParty.get("https://seeclickfix.com/api/v2/issues.json?place_url=raleigh&status=open&after=#{@update_date}&page=1&per_page=1000").to_hash
     @results['issues'].each do |a|
     @is_new = Issue.where(["issue_id  = ? ", a["id"]]).first.to_json 
         if @is_new.nil? #issue is not in our database so we should add it
            @issue = Issue.new 
            @issue.issue_id = a["id"]
            @issue.summary = a["summary"] 
            @issue.description a["description"]
            @issue.status = a["status"]
            @issue.address = a["address"]
            @issue.rating = a["rating"]
            @issue.lat = a["lat"]
            @issue.lng = a["lng"]
            @issue.url = a["url"]
            @issue.user_id = a["reporter"]["id"]
            @issue.created_at =a["created_at"] 
            @issue.updated_at = a["updated_at"]
            @issue.acknowledged_at = a["acknowledged_at"]
            @issue.closed_at = a["closed_at"]
            @issue.save! 
            @payload << @issue
            @count+=1
        end
      end
     puts @count.to_s + ' new records'
     see_click_update
  end
 
  def see_click_update #check all (non-archived) issues for status change & add to payload array for upload to socrata
    @issue_up = Issue.where(["status != ?", "Archived"]).all
    @issue_up.each do |compare|
      response = HTTParty.get("http://seeclickfix.com/api/v2/issues/#{compare.issue_id}").to_hash
      @issue=response
      puts response['id']
      puts '---------------------------------------'
      if compare.status == "Open"  && @issue['status'] == "Acknowledged"
        compare.status = "Acknowledged"
        compare.updated_at = @issue['updated_at'] 
        compare.acknowledged_at = @issue['acknowledged_at'] 
        compare.save!
        @payload << compare
      elsif compare.status == "Acknowledged" && @issue['status'] == "Closed"
        compare.status = "Closed"
        compare.updated_at = @issue['updated_at']
        compare.closed_at = @issue['closed_at']
        compare.save!
        @payload << compare
      elsif compare.status == "Closed" && @issue['status'] == "Archived"
        compare.status = "Archived"
        compare.updated_at = @issue['updated_at']
        compare.archived_at = @issue['archived_at'] 
        compare.save!
        @payload << compare     
       end
    end
    export
  end

   
  def export #push all to Socrata
   puts @payload.to_json
   puts @payload.size
#    response = @client.post(@view_id, @payload)         #upload to Socrata
#    
#    puts response["Errors"].to_s + ' Errors'
#    puts response["Rows Deleted"].to_s + ' Rows Deleted'
#    puts response["Rows Created"].to_s + ' Rows Created'
#    puts response["Rows Updated"].to_s + ' Rows Updated'
#    LOGGER.info "Update complete using duncanQuery"
#    LOGGER.info "................. #{response["Errors"]} Errors"
#    LOGGER.info "................. #{response["Rows Deleted"]} Rows Deleted"
#    LOGGER.info "................. #{response["Rows Created"]} Rows Created"
#    LOGGER.info "................. #{response["Rows Updated"]} Rows Updated"
   end 
end
Issue.new.see_click_new