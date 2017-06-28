class AddDeletedAtToSavedListings < ActiveRecord::Migration
  def change
    add_column :saved_listings, :deleted_at, :datetime
  end
end
