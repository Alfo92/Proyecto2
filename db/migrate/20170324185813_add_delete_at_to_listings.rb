class AddDeleteAtToListings < ActiveRecord::Migration
  def change
    add_column :listings, :deleted_at, :datetime
  end
end
