class CreateSavedListings < ActiveRecord::Migration
  def change
    create_table :saved_listings do |t|
      t.integer :user_id
      t.integer :listing_id
      t.integer :sort_order
      t.text :notes

      t.timestamps null: false
    end
  end
end
