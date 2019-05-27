#!/usr/bin/env ruby

require 'sinatra/base'
require 'json'
require 'sinatra/activerecord'
require 'pry'

EnrollSecret = "somesecret"

class FleetManager < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :bind, '0.0.0.0'
    set :environment, 'development'
    set :database, 'sqlite3:db/database.db'
  end

  before do
    content_type 'application/json'
  end

  post '/enroll' do
    body = request.body.read
    puts '/enroll: ' + body
    parsed_body = JSON.parse(body)
    if parsed_body["enroll_secret"] == EnrollSecret
      {
        "node_key": "some-node-key",
        "node_invalid": false
      }.to_json
    else
      {
        "node_key": "",
        "node_invalid": true
      }.to_json
    end
  end

  post '/configuration' do
    puts '/configuration: ' + request.body.read
    File.read('config.json')
  end
end

class Client < ActiveRecord::Base
  serialize :host_details
  validates_presence_of :host_identifier

end
