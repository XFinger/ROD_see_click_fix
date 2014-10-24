#require_relative './app/api'
#require_relative './app/scf.rb'
#require File.expand_path("../app/api", __FILE__)
#require File.expand_path("../app/scf", __FILE__)


require 'sinatra'
require 'sinatra/base'
require 'grape'
require 'rabl'
require 'grape/rabl'
 
require 'rack/cors'
require './app/api.rb'
require './app/scf.rb'
 

set :root, File.dirname(__FILE__) # You must set app root

use Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :delete, :options]
  end
end
 

use Rack::Config do |env|
  env['api.tilt.root'] = './app/views'
end

#use Rack::Session::Cookie
run Rack::Cascade.new [Api,Scf]