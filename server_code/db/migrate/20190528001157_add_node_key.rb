class AddNodeKey < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :node_key, :string
  end
end
