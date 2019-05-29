class Client < ActiveRecord::Base
  serialize :host_details
  validates_presence_of :host_identifier, :node_key
end