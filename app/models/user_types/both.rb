# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  name                   :string(255)      default(""), not null
#  phone_number           :string(255)
#  company                :string(255)
#  about                  :text(65535)
#  type                   :string(255)
#  kind                   :string(255)
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  total_profile_views    :integer
#  subscribed             :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  views_count            :integer          default(0)
#  provider               :string(255)
#  uid                    :string(255)
#

class Both < User
  
  def self.model_name
    User.model_name
  end
end
