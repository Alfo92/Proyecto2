class DefineSortValue < ActiveRecord::Migration
  def change
    priority = ["apartment","house", "duplex", "land","commercial_building","warehouse","office","farm"]
    ListingType.all.each do |lt|
      order = priority.index(lt.name)
      lt.update_attributes(SortValue: order)
    end
  end
end
