# == Schema Information
#
# Table name: listing_properties
#
#  id         :integer          not null, primary key
#  listing_id :integer
#  key        :string(255)
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ListingPropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
