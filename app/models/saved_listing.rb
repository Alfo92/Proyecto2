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

class SavedListing < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :listing
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :listing_id
end
