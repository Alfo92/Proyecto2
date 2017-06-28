class CreateListingPhotos < ActiveRecord::Migration
  def change
    create_table :listing_photos do |t|
      t.attachment :file
      t.string :file_fingerprint
      t.string  :name
      t.string  :comment
      t.integer :sort_order
      t.integer :listing_id
      
      t.timestamps null: false
    end
  end
end
