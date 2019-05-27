#!/usr/bin/env ruby

require 'sinatra/base'
require 'json'

EnrollSecret = "somesecret"

class FleetManager < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :environment, 'development'
  end

  before do
    content_type 'application/json'
  end

  post '/enroll' do
    puts request.body.read
    {
      "node_key": "some-node-key",
      "node_invalid": false
    }.to_json
  end

  post '/configuration' do
    puts request.body.read
    File.read('config.json')
  end
end
