json.array!(@saved_listings) do |saved_listing|
  json.extract! saved_listing, :id, :user_id, :listing_id, :sort_order, :notes
  json.url saved_listing_url(saved_listing, format: :json)
end
