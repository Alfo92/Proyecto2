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

class Message < ActiveRecord::Base

  belongs_to :from_user, class_name: "User", foreign_key: "from_id"
  belongs_to :to_user, class_name: "User", foreign_key: "to_id", with_deleted: true
  belongs_to :listing
  
  after_create :send_message


#  private

  def send_message
    MessageMailer.new_message(self).deliver
  end
end
