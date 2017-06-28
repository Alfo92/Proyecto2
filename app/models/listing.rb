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

class Listing < ActiveRecord::Base
  acts_as_paranoid

  STATUS = [:inactive,:active]
  LISTING_TYPE = [:rent, :sale]
  PRICE_TYPE = [:dolares, :guarani]
  PRICE_TYPE_SYMBOL = {dolares: 'USD', guarani: 'PYG'}.with_indifferent_access
  STATUS_TYPE = [:nuevo, :renovado]
  PRICE_RANGE = [["0-1000","0 a 1000 $"], ["1000-10000","1000 a 10000 $"], ["10000-50000","10000 a 50000 $"], ["50000-100000","50000 a 100000 $"], ["100000-200000","100000 a 200000 $"], ["200000-300000","200000 a 300000 $"], ["300000","300000$ o más"]]
  has_many :listing_properties, dependent: :destroy, autosave: true
  has_many :listing_photos, -> {order 'sort_order ASC'}, autosave: true, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  
  belongs_to :agent, class_name: "User", with_deleted: true
  belongs_to :primary_photo, class_name: "ListingPhoto", foreign_key: "primary_photo_id", dependent: :destroy

  validates :accepts_terms, acceptance: true, if: Proc.new{|listing| listing.status_id_changed? && listing.active?}
  validates_presence_of :agent_id
  validates :listing_type, :price_type, :list_price, :list_date, :address1, :city, :state, :country, :latitude, :longitude, presence: true
  
  after_initialize :init_properties
  before_save      :build_properties, :set_full_info
  after_find       :assign_properties

  attr_accessor :accepts_terms, :properties
  serialize :properties
  # Obs.: general property and general listing are used only for view display porposes
  RATEABLE = ["safety", "price", "location", "public_services", "complete_info", "image_quality", "speed_agility_answer", 'general_property', 'general_listing']
  ratyrate_rateable *RATEABLE

  accepts_nested_attributes_for :listing_photos
  geocoded_by :full_address
  reverse_geocoded_by :latitude, :longitude


  scope :for_sale, lambda{ where({listing_type: LISTING_TYPE.index(:sale),:sold => [nil, false]})}
  scope :for_rent, lambda{ where({listing_type: LISTING_TYPE.index(:rent),:sold => [nil, false]})}
  scope :sold, lambda{ where(:sold => true)}
  scope :ready, lambda{ includes(:listing_properties, :listing_photos, :primary_photo).where(accept_terms: true)}
  scope :everything, lambda { }
  scope :interesting, -> {all.sample(5)}
  scope :recently_sold, ->(current_listing){
    near([current_listing.latitude, current_listing.longitude], 50, units: :km).
    where(sold: true).
    limit(5).to_a
  }
  default_scope {joins('INNER JOIN "users" ON "users"."id" = "listings"."agent_id"').where("(users.disabled_at is null and users.deleted_at is null) or listings.sold=true")}

  def self.search_by_radius(lon, lat, radius, options = {})
    Listing.select(Listing.column_names.join(",")+", ( 3959 * acos( cos( radians(#{lon}) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(#{lat}) ) + sin( radians(#{lon}) ) * sin(radians(latitude)) ) ) AS distance")
    .having("distance < #{radius}")
  end

  #good for searching within a map
  def self.search_within_bounds(lon1,lat1,lon2,lat2)
    where('longitude > ? and longitude < ? and latitude > ? and latitude < ?', lon1,lon2,lat1,lat2)
  end

  def self.search(params)
    where(true)
  end

  def property_general_rate
    number_of_categories = 4
    sum_of_rates = 0
    ['safety_average', 'price_average', 'location_average', 'public_services_average'].each do |rate_property|
      if !(result = send(rate_property) ).nil?
        sum_of_rates += result.avg
      end
    end
    sum_of_rates / number_of_categories
  end

  def listing_general_rate
    number_of_categories = 3
    sum_of_rates = 0
    ['complete_info_average', 'image_quality_average', 'speed_agility_answer_average'].each do |rate_property|
      if !(result = send(rate_property) ).nil?
        sum_of_rates += result.avg
      end
    end
    sum_of_rates / number_of_categories
  end

  def update_current_rate(stars, user, dimension)
    current_rate = Rate.where(rateable_id: id, rateable_type: 'Listing', dimension: dimension).first
    current_rate.stars = stars
    current_rate.save!(validate: false)

    if rates(dimension).count > 1
      update_rate_average(stars, dimension)
    else # Set the avarage to the exact number of stars
      a = average(dimension)
      if a
        a.avg = stars
        a.save!(validate: false)
      end
    end
  end

  #todo: ensure this is correct for SA
  def full_address
    "#{address1} #{address2} #{city},#{state} #{postal_code} #{country}"
  end

  def search_address
    "#{address1} #{address2} #{city}, #{state}"
  end

  def short_address
    "#{address1} #{address2} #{city}"
  end

  def quick_look
    #todo:do this
    listing_properties.select{|p| p.key == 'short_description'}.first.try(:value) || address1
  end

  def active?
    STATUS[status_id] == :active
  end

  def for_rent?
    listing_type == LISTING_TYPE.index(:rent)
  end

  def real_price_formatted
    if (self.list_price != nil)
      if self.price_type.to_s == "guarani"
        Money.new(self.list_price, "PYG").format(no_cents: true, thousands_separator: '.')
      else
        Money.new(self.list_price, "USD").format(symbol: "USD ")
      end
    end
  end

  def other_price_formatted
    if (self.list_price != nil)
      if self.price_type.to_s == "guarani"
        Money.new(self.list_price, "PYG").exchange_to("USD").format(symbol: "USD ")
      else
        Money.new(self.list_price, "USD").exchange_to("PYG").format
      end
    end
  end

  # def self.search(params)
  #
  #
  #
  #
  #   #count_for = 0
  #   #text_search = ""
  #  # params.each do |key,value|
  #   #  count_for = count_for++
  #   #  if !value.is_a? Array
  #   #    if count_for == 1
  #   #      text_search = "#{value}"
  #    #   else
  #    #     text_search = "#{text_search} #{value}"
  #     #  end
  #    # end
  #   #end
  #   if params[:type].is_a? Array
  #     text_type = params[:type].map {|str| "#{str}"}.join(',')
  #
  #   else
  #     text_type = ""
  #   end
  #   text_type.sub('"', '')
  #
  #   text_listing_type = nil
  #   if params[:listing_type] == "rent"
  #      text_listing_type = 0
  #   elsif params[:listing_type] == "sale"
  #      text_listing_type = 1
  #   end
  #
  #   if params[:where].class == String
  #     listing_ids = ListingProperty.where('value like ?', "%#{params[:where]}%").all.collect {|p|p.listing_id}.uniq
  #     if params[:price_range] != nil
  #        price_min = params[:price_range].to_s.split('-')[0]
  #        price_max = params[:price_range].to_s.split('-')[1]
  #        if price_max != nil
  #           if !listing_ids.empty?
  #             listings = where("(description LIKE ? or address1 like ? or address2 like ? or city like ? or state like ? or id in (?)) and type IN (?) and listing_type = ? and list_price >= ? and list_price <= ?", "%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%", listing_ids,params[:type], text_listing_type,price_min,price_max)
  #           else
  #             listings = where("(description LIKE ? or address1 like ? or address2 like ? or city like ? or state like ?) and type IN (?) and listing_type = ? and list_price >= ? and list_price <= ?", "%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%",params[:type], text_listing_type,price_min,price_max)
  #           end
  #        else
  #           if !listing_ids.empty?
  #             listings = where("(description LIKE ? or address1 like ? or address2 like ? or city like ? or state like ? or id in (?)) and type IN (?) and listing_type = ? and list_price >= ? ", "%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%", listing_ids,params[:type], text_listing_type,price_min)
  #           else
  #             listings = where("(description LIKE ? or address1 like ? or address2 like ? or city like ? or state like ?) and type IN (?) and listing_type = ? and list_price >= ? ", "%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%",params[:type], text_listing_type,price_min)
  #           end
  #        end
  #     else
  #       if !listing_ids.empty?
  #         listings = where("(description LIKE ? or address1 like ? or address2 like ? or city like ? or state like ? or id in (?)) and type IN (?) and listing_type = ?", "%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%", listing_ids,params[:type], text_listing_type)
  #       else
  #         listings = where("(description LIKE ? or address1 like ? or address2 like ? or city like ? or state like ?) and type IN (?) and listing_type = ?", "%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%","%#{params[:where]}%",params[:type], text_listing_type)
  #       end
  #     end
  #   else
  #     listings = where('list_price >= ? && list_price <= ?', params[:price_min], params[:price_max])
  #     if params[:type].present?
  #       listings = listings.where(:type => params[:type])
  #     end
  #     listings
  #   end
  # end

  def set_full_info
    attributes_text = attributes.except("id", "created_at", "updated_at", "agent_id", "primary_photo_id", "latitude", "longitude", "views_count", "step", "location_id", "status_id").values.select{|e| e}.join(" ")
    properties_text = listing_properties.map(&:value).select{|e| e}.join(" ")
    self.full_info = ActiveSupport::Inflector.transliterate("#{attributes_text} #{properties_text}")
  end  

  def can_send_message?
    if self.agent.can_send_message?
      true
    else
      false
    end
  end  

  private

  def init_properties
    self.properties ||= {}
  end

  #create listing properties from hash for easy searching
  def build_properties
    properties.each do |key,val|
      prop = listing_properties.find_or_initialize_by(key:key)
      prop.value = val

    end
  end 

  #make properties more easily accesible through this hash
  def assign_properties
    self.properties ||= {}
    listing_properties.each do |prop|
      self.properties[prop.key] ||= prop.value
    end
  end

end
