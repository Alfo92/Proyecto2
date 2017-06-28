class SetListingsFullInfo < ActiveRecord::Migration
  def change
    Listing.all.each{|l| l.set_full_info; l.save }
  end
end
