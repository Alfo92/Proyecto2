module ListingsHelper

  def active_class(me,step)
    raw('class="active"') if me <= step
  end

  def yes_no_options
    ["Yes", "No"]
  end

  def building_state_options
    ["new", "under construction", "renovated"]
    ["nuevo", "a estrenar", "renovado"]
  end

  def service_area_options
    ["Nada", "1BR","1BR, 1BA","2BR, 1BA"]
  end 

  def parking_options
    ["Street", "1 Car", "2 Cars"]
  end

  def commercial_parking_options
    ["Street"] + (1..10).to_a
  end


  def house_type_options
    ["Mansion", "Duplex", "Townhouse"]
  end

  def roadway_options
    ["Dirt", "Asphalt", "Concrete"]
  end

  def for_sale_or_rent(listing)
    listing.for_rent? ? t('listings.for_rent') : t('listings.for_sale')
  end 

  def listing_price(listing)
    list_price = number_to_currency(listing.list_price, unit: "#{Listing::PRICE_TYPE_SYMBOL[listing.price_type]} ", precision: 0)
    "#{list_price} #{t('listings.per_month') if listing.for_rent?}"
  end

  def listing_price_short(listing)
    listing.real_price_formatted
  end

  def listing_other_price_short(listing)
    if listing.price_type.to_s == "guarani"
      amount = Money.new(listing.list_price, "PYG").exchange_to("USD")
      number_to_currency(amount, unit: "#{Listing::PRICE_TYPE_SYMBOL[:dolares]} ", precision: 0)
    else
      amount = Money.new(listing.list_price, "USD").exchange_to("PYG")
      number_to_currency(amount * 100, unit: "#{Listing::PRICE_TYPE_SYMBOL[:guarani]} ", precision: 0)
    end
  end

  def listing_other_price(listing)
    "#{listing_other_price_short(listing)} #{t('listings.per_month') if listing.for_rent?}"
  end
end
