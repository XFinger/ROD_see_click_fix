require "bundler/setup"
require 'rubygems'
require 'sinatra'
require 'sinatra-initializers' 
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/assetpack'
require './environments'
require './models/issue'  
require 'json'
require 'rabl'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'
require './lib/decimal_helper' 
require 'oj'
require 'grape'
require_relative '../config/rabl.rb'

 
 Rabl.register!
 
class Scf < Sinatra::Base 



get '/' do
  
  @thisday = Date.today - 30
  @thedate = @thisday.strftime("%m/%d/%Y")
  @count_open = Issue.is_open.size
  @count_ack =Issue.is_ack.size
  @count_closed = Issue.is_closed.size
  @count_arc= Issue.is_archived.size
  @issue = Issue.is_closed
 # @mark=Issue.find(72)
  @closed_issues= Issue.is_closed
  @open_issues= Issue.is_open#.is_on(@thedate)
  @ack_issues = Issue.is_ack 
  @all_issues = Issue.is_open 
  @open = rabl :open
  @closed = rabl :closed
  @acknowledged = rabl :ack
  @all = rabl :all
  
  
  @page_title = "Welcome Page"
  erb :welcome
end


end
 


 


 
 

