class CreateClient < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :host_identifier
      t.text :host_details
    end
  end
end
