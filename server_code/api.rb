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
      cli = Client.where(host_identifier: parsed_body['host_identifier']).first_or_create
      cli.host_details = parsed_body['host_details']
      cli.node_key = Client.generate_key
      #  TODO: validation fails?
      if cli.save!
        {
          "node_key": cli.node_key,
          "node_invalid": false
        }.to_json
      end
    else
      status 400
      {
        "node_invalid": true
      }.to_json
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
      {
        "node_invalid": true
      }.to_json
    end
  end
end

class Client < ActiveRecord::Base
  serialize :host_details
  validates_presence_of :host_identifier, :node_key

  def self.generate_key
    node_key = SecureRandom.hex(20)
  end

end
