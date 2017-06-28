# == Schema Information
#
# Table name: listing_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  SortValue  :integer

class ListingType < ActiveRecord::Base

  def self.lookup
    @@lookup ||= ListingType.all.collect.sort_by{|l| l.SortValue }.collect{|l|l.name}
  end
end
