# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  from_id    :string(255)
#  from_name  :string(255)
#  from_email :string(255)
#  from_phone :string(255)
#  message    :string(255)
#  to_id      :integer
#  to_email   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
