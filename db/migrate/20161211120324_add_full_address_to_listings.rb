class AddFullAddressToListings < ActiveRecord::Migration
  def change
    add_column :listings, :full_info, :text
    add_index :listings, :full_info
  end
end
