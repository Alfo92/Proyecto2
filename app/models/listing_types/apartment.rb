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

class Apartment < Listing

  PROPERTIES = [ :monthly_expenses, :payment_options, :floor, :square_meters, :square_meters_communal, :building_state,
                 :amenities, :bedrooms, :bathrooms, :parking, :building_name, :location_description, :short_description,
                 :other_info ]
  ADVANCED_SEARCH_PROPERTIES = [:floor, :square_meters, :bedrooms, :bathrooms, :parking, :building_state]
                
  AMENITIES = [:pool, :gym, :waterfront,:elevator,:playground,:pond,:clubhouse]  
  ROOMS     = [:laundry, :dining, :study, :den, :office]

  def amenities

  end

  def self.model_name
    Listing.model_name
  end
end
