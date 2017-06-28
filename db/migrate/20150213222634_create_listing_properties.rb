class CreateListingProperties < ActiveRecord::Migration
  def change
    create_table :listing_properties do |t|
      t.integer :listing_id
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
