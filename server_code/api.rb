#!/usr/bin/env ruby

require 'sinatra/base'
require 'sinatra/activerecord'
require 'json'
require_relative 'models/client'

EnrollSecret = ENV['ENROLL_SECRET']

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

  def generate_key
    SecureRandom.hex(20)
  end

  helpers do
    def node_invalid_response
      status 400
      {
        'node_key': '',
        'node_invalid': true
      }.to_json
    end
  end

  post '/enroll' do
    body = request.body.read
    puts '/enroll: ' + body
    parsed_body = JSON.parse(body)
    if parsed_body["enroll_secret"] == EnrollSecret
      cli = Client.where(host_identifier: parsed_body['host_identifier']).first_or_create
      cli.host_details = parsed_body['host_details']
      cli.node_key = generate_key
      if cli.save!
        {
          'node_key': cli.node_key,
          'node_invalid': false
        }.to_json
      else
        node_invalid_response
      end
    else
      node_invalid_response
    end
  end

  post '/configuration' do
    body = request.body.read
    puts '/configuration: ' + body
    parsed_body = JSON.parse(body)
    cli = Client.where(node_key: parsed_body['node_key']).first
    if cli
      File.read('config.json')
    else
      node_invalid_response
    end
  end
end

