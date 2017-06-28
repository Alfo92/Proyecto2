class AddSortValueToListingTypes < ActiveRecord::Migration
   def change
  	add_column :listing_types, :SortValue, :integer , :default => "1"
    # execute "update listing_types set SortValue = 1 where name ='house' "
    # execute "update listing_types set SortValue = 2 where name ='apartment' "
    # execute "update listing_types set SortValue = 3 where name ='duplex' "
    # execute "update listing_types set SortValue = 4 where name ='farm' "
    # execute "update listing_types set SortValue = 5 where name ='cottage' "
    # execute "update listing_types set SortValue = 6 where name ='land' "
    # execute "update listing_types set SortValue = 7 where name ='commercial_building' "
    # execute "update listing_types set SortValue = 8 where name ='office' "
    # execute "update listing_types set SortValue = 9 where name ='fieldstay' "
    # execute "update listing_types set SortValue = 10 where name ='warehouse' "
    # execute "update listing_types set SortValue = 11 where name ='subdivision' "
  end
end
