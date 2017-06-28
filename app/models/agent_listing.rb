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

class AgentListing < ActiveRecord::Base
end
