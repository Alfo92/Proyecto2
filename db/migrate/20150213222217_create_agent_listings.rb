class CreateAgentListings < ActiveRecord::Migration
  def change
    create_table :agent_listings do |t|
      t.integer :agent_id
      t.integer :listing_id

      t.timestamps null: false
    end
  end
end
