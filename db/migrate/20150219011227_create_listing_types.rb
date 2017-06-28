class CreateListingTypes < ActiveRecord::Migration
  def change
    create_table :listing_types do |t|
      t.string :name

      t.timestamps null: false
    end
    
    ListingType.create(["apartment","house", "duplex", "land","commercial_building","warehouse","office","farm"].collect{|i| {name: i}})

  end
end
