#!/usr/bin/env ruby

require 'sinatra/base'
require 'json'
require 'sinatra/activerecord'

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
    puts '/enroll: ' + request.body.read
    {
      "node_key": "some-node-key",
      "node_invalid": false
    }.to_json
  end

  post '/configuration' do
    puts '/configuration: ' + request.body.read
    File.read('config.json')
  end
end

class Client < ActiveRecord::Base
  serialize :host_details

end
