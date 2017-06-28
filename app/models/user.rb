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

class User < ActiveRecord::Base
  extend Enumerize
  acts_as_paranoid

  TYPES=["Buyer", "Seller", "Both"]
  has_one :agent_profile
  has_many :listings, foreign_key: "agent_id"
  has_many :saved_listings
  has_many :views, as: :viewable
  has_many :received_messages, class_name: "Message", foreign_key: "to_id"
  has_many :searches, class_name: "SearchHistory"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  before_save :build_default_agent_profile, if: Proc.new { |user| user.is_agent? && user.agent_profile.nil? }
  before_save :format_phone

  enumerize :language, in: [:es, :en], predicates: true
  #after_save :send_email_user
  scope :find_enabled, ->(id){ where(id: id, disabled_at: nil).first}

  has_attached_file :avatar, :styles => { :medium => ["322x322#", :png], :thumb => "100x100#", :mini => ["29x29#", :png] },
                    :default_url => ":style-avatar-missing.png",
                    :storage => :s3,
                    :path => "/users/:attachment/:id_partition/:style/:filename",
                    :s3_host_name => 's3-sa-east-1.amazonaws.com',
                    :s3_credentials => Proc.new{ |a| storage_s3_credentials }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  #phony_normalize :phone_number, :default_country_code => 'PY'

  def is_listing_owner(listing)
    listing.agent_id==self.id ? true : false
  end

  def is_agent?
    type != "Buyer"
  end

  def recent_profile_views
    #todo:
    7
  end

  def first_name
    name.split(" ")[0]
  end

  def add_view!(ip_address)
    update(total_profile_views:(total_profile_views.to_i+1))
  end

  def self.from_omniauth(auth)
    logger.info("@@@@@@@@@@@@@@@@")
    logger.info(auth.inspect)
    logger.info(KEYS)
    where(email: auth.info.email).first_or_create do |user|
      user.provider = auth.provider,
      user.uid = auth.uid,
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    user = User.new
    if params
      user_attrs = nil
      if params[:user]
        user_attrs[:user].with_indifferent_access
      elsif params[:resource]
        user_attrs[:resource].with_indifferent_access
      end

      if user_attrs
        user.assign_attributes(
        email: user_attrs[:email],
        encrypted_password: user_attrs[:encrypted_password],
        reset_password_token: user_attrs[:reset_password_token],
        reset_password_sent_at: user_attrs[:reset_password_sent_at],
        remember_created_at: user_attrs[:remember_created_at],
        sign_in_count: user_attrs[:sign_in_count],
        current_sign_in_at: user_attrs[:current_sign_in_at],
        last_sign_in_at: user_attrs[:last_sign_in_at],
        current_sign_in_ip: user_attrs[:current_sign_in_ip],
        last_sign_in_ip: user_attrs[:last_sign_in_ip],
        confirmation_token: user_attrs[:confirmation_token],
        confirmed_at: user_attrs[:confirmed_at],
        confirmation_sent_at: user_attrs[:confirmation_sent_at],
        unconfirmed_email: user_attrs[:unconfirmed_email],
        name: user_attrs[:name],
        phone_number: user_attrs[:phone_number],
        company: user_attrs[:company],
        about: user_attrs[:about],
        type: user_attrs[:type],
        kind: user_attrs[:kind],
        avatar_file_name: user_attrs[:avatar_file_name],
        avatar_content_type: user_attrs[:avatar_content_type],
        avatar_file_size: user_attrs[:avatar_file_size],
        avatar_updated_at: user_attrs[:avatar_updated_at],
        total_profile_views: user_attrs[:total_profile_views],
        subscribed: user_attrs[:subscribed],
        created_at: user_attrs[:created_at],
        updated_at: user_attrs[:updated_at],
        views_count: user_attrs[:views_count],
        provider: user_attrs[:provider],
        uid: user_attrs[:uid],
        customer_id: user_attrs[:customer_id],
        language: user_attrs[:language],
        oauth_token: user_attrs[:oauth_token],
        oauth_expires_at: user_attrs[:oauth_expires_at])
      end
    end

    if session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      data = session["devise.facebook_data"]
      raw_data = session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = raw_data["email"] if user.email.blank?
      user.name = raw_data["name"] if user.name.blank?
      user.avatar = URI.parse(raw_data["picture"]["data"]["url"]) if user.avatar.blank?
      user.provider = data["provider"]
      user.uid = data["uid"]
    end
    user
  end

  def country_code
    I18n.t('country_code')
  end

  def profile_summary
    summary = []
    attributes = [:email, :phone_number]
    attributes.each do |attr|
      attr_value = send(attr)
      unless attr_value.blank?
        summary << attr_value
      end
    end
    summary
  end

  def disable
    self.update(disabled_at: DateTime.now)
  end

  def enable
    self.update(disabled_at: nil)
  end

  def can_send_message?
    if self.disabled_at || self.deleted_at
      false
    else
      true
    end
  end  

  private

  def build_default_agent_profile
    build_agent_profile
  end

  def send_email_user
    UserEmail.bienvenido_email(self).deliver
  end

  def format_phone
    default_country_code = '+595'
    if phone_number && !phone_number.include?(default_country_code)
      first_digit = phone_number[0]
      if first_digit.to_s == '0'
        rest_of_number = phone_number[1 .. -1]
      elsif phone_number[4] != " "
        rest_of_number = phone_number[4 .. -1]
      else
        rest_of_number = phone_number
      end
      self.phone_number = "#{default_country_code} #{rest_of_number}"
    end
  end
end
