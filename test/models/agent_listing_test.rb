# == Schema Information
#
# Table name: agent_listings
#
#  id         :integer          not null, primary key
#  agent_id   :integer
#  listing_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AgentListingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
