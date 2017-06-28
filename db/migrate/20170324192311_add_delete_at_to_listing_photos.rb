class AddDeleteAtToListingPhotos < ActiveRecord::Migration
  def change
    add_column :listing_photos, :deleted_at, :datetime
  end
end
