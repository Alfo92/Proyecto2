# == Schema Information
#
# Table name: views
#
#  id            :integer          not null, primary key
#  viewable_type :string(255)
#  viewable_id   :integer
#  ip_address    :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class View < ActiveRecord::Base
  belongs_to :viewable, polymorphic: true, counter_cache:true
end
