# == Schema Information
#
# Table name: saved_listings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  listing_id :integer
#  sort_order :integer
#  notes      :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SavedListingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
