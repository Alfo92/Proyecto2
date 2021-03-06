# == Schema Information
#
# Table name: listings
#
#  id               :integer          not null, primary key
#  type             :string(255)
#  listing_type     :integer
#  featured         :boolean
#  description      :text(65535)
#  property_url     :string(255)
#  step             :integer          default(0)
#  location_id      :integer
#  agent_id         :integer
#  status_id        :integer          default(0), not null
#  list_price       :decimal(10, )
#  list_date        :date
#  primary_photo_id :integer
#  hide_address     :boolean
#  address1         :string(255)
#  address2         :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  country          :string(255)
#  latitude         :float(24)
#  longitude        :float(24)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sold             :boolean          default(FALSE)
#  views_count      :integer          default(0)
#  price_type       :string(50)
#

class Cottage < Listing

  PROPERTIES = [:payment_options, :condominium_name, :condominium_desc, :square_meters_built, :square_meters_land,
                :building_state, :parking_number, :bedrooms, :bathrooms, :location_description, :short_description, :other_info]

  ADVANCED_SEARCH_PROPERTIES = [:payment_options, :condominium_name, :condominium_desc, :square_meters_built, :square_meters_land,
                                :building_state, :parking_number, :bedrooms, :bathrooms, :location_description, :short_description, :other_info]

  def self.model_name
    Listing.model_name
  end
end
