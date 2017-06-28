class AddForeignKeyToTables < ActiveRecord::Migration
  def change
    #add_foreign_key :agent_listings, :agents
    add_foreign_key :agent_listings, :listings
    add_foreign_key :agent_profiles, :users
    add_foreign_key :average_caches, :users, column: :rater_id
    add_index :average_caches, :rateable_id
    add_index :average_caches, :rateable_type
    add_foreign_key :listing_photos, :listings
    add_index :listing_photos, :sort_order
    add_foreign_key :listing_properties, :listings
    add_index :listing_properties, :key
    add_index :listing_types, :SortValue
    add_index :listings, :type
    add_index :listings, :listing_type
    #add_foreign_key :listings, :locations
    #add_foreign_key :listings, :agents
    #add_foreign_key :listings, :status
    add_foreign_key :listings, :listing_photos, column: :primary_photo_id
    add_foreign_key :messages, :users, column: :to_id
    #change_column :messages, :from_id, :integer
    change_column :messages, :from_id, 'integer using cast(from_id as integer)'

    add_foreign_key :messages, :users, column: :from_id
    add_foreign_key :messages, :listings
    add_index :overall_averages, :rateable_id
    add_index :overall_averages, :rateable_type
    add_foreign_key :rates, :users, column: :rater_id
    add_foreign_key :saved_listings, :users
    add_foreign_key :saved_listings, :listings
    add_index :saved_listings, :sort_order
    add_foreign_key :search_histories, :users
    #add_foreign_key :users, :customers
    add_index :views, :viewable_id
    add_index :views, :viewable_type
  end
end
