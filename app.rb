require "bundler/setup"
require 'rubygems'
require 'sinatra'
require 'gon-sinatra' 
require 'sinatra/activerecord'
require './environments'
require './models/issue'  
require 'json'
require 'sinatra-initializers'
require 'rabl'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'builder'
require 'bigdecimal' 
require 'oj'
require_relative './config/rabl.rb'
 
 Rabl.register!
 Sinatra::register Gon::Sinatra
 Sinatra::register Gon::Sinatra::Rabl

class BigDecimal
  def as_json(options = nil) #:nodoc:
    if finite?
      self
    else
      NilClass::AS_JSON
    end
  end
end
 

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
  @open = rabl :open
  @closed = rabl :closed
  @acknowledged = rabl :ack
 
  @page_title = "Welcome Page"
  erb :welcome
end
get '/api/closed_issues.geojson' do
  @closed_issues = Issue.is_closed
  rabl :closed
end 
get '/api/open_issues.geojson' do
  @open_issues = Issue.is_open
  rabl :open
end 
get '/api/acknowledged_issues.geojson' do
  @ack_issues= Issue.is_ack
  rabl :ack
end 
  

