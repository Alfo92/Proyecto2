# == Schema Information
#
# Table name: agent_profiles
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  license     :string(255)
#  specialties :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class AgentProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
