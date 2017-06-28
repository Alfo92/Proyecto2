# == Schema Information
#
# Table name: listing_photos
#
#  id                :integer          not null, primary key
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  file_fingerprint  :string(255)
#  name              :string(255)
#  comment           :string(255)
#  sort_order        :integer
#  listing_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ListingPhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
