class AddViewCountToListings < ActiveRecord::Migration
  def change
    add_column :listings, :views_count, :integer,default:0
    add_column :users, :views_count, :integer,default:0
  end
end
