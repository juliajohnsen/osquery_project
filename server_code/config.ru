require 'dotenv'
Dotenv.load

require_relative 'api'
run FleetManager.new
