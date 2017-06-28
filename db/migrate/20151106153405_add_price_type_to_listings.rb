class AddPriceTypeToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :price_type, :string , :default => "dolares"
  end
end
