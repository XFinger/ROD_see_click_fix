# for swagger documentation go to  http://localhost:9292/api/swagger_doc


require "bundler/setup"
require 'rubygems'
require 'sinatra'
require 'sinatra-initializers'
require 'sinatra/activerecord'
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
require 'grape/rabl'
require 'grape-swagger'
require_relative '../config/rabl.rb'

 Rabl.register!

 class Api < Grape::API
    prefix 'api'
   #default_format :json
   formatter :json, Grape::Formatter::Rabl

       desc "Acknowledged see click fix issues", {
        :notes => <<-NOTE
           All Raleigh see click fix issues with a status of 'Acknowledged'
        NOTE
      }
      get 'acknowledged' do
        @issues = Issue.is_ack
      end

       desc "Acknowledged see click fix issues in geojson format", {
        :notes => <<-NOTE
       All Raleigh see click fix issues with a status of 'Acknowledged' in geojson format
        NOTE
      }

      get 'geo/acknowledged', :rabl => "issues.rabl" do
        @issues = Issue.is_ack
      end

      desc "Closed see click fix issues", {
       :notes => <<-NOTE
          All Raleigh see click fix issues with a status of 'Closed'
       NOTE
     }
      get 'closed' do
        @issues = Issue.is_closed
      end

      desc "Closed see click fix issues in geojson format", {
       :notes => <<-NOTE
          All Raleigh see click fix issues with a status of 'Closed' in geojson format
       NOTE
     }
      get 'geo/closed' , :rabl => "issues.rabl" do
        @issues = Issue.is_closed
      end

      desc "Open see click fix issues", {
         :notes => <<-NOTE
            All Raleigh see click fix issues with a status of 'Open'
         NOTE
       }
      get 'open' do
        @issues = Issue.is_open
      end

      desc "Open see click fix issues in geojson format", {
       :notes => <<-NOTE
          All Raleigh see click fix issues with a status of 'Open' in geojson format
       NOTE
     }
      get 'geo/open' , :rabl => "issues.rabl" do
        @issues = Issue.is_open
      end

      desc "All see click fix issues", {
          :notes => <<-NOTE
            All Raleigh see click fix issues
          NOTE
      }
      get 'all_issues' do
        @issues = Issue.all
      end

      desc "All see click fix issues in geojson format", {
          :notes => <<-NOTE
            All Raleigh see click fix issues in geojson format
          NOTE
      }
      get 'geo/all_issues', :rabl => "issues.rabl" do
        @issues= Issue.all
      end

      desc "Archived see click fix issues in geojson format", {
       :notes => <<-NOTE
          All Raleigh see click fix issues with a status of 'Archived'
       NOTE
     }
      get 'archived' do
        @issues = Issue.is_archived
      end

      desc "Archived see click fix issues  in geojson format", {
       :notes => <<-NOTE
          All Raleigh see click fix issues with a status of 'Archived' in geojson format
       NOTE
     }
      get 'geo/archived', :rabl => "issues.rabl" do
        @issues= Issue.is_archived
      end

        add_swagger_documentation

      end
