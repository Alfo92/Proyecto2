json.array!(@views) do |view|
  json.extract! view, :id, :viewable_type, :viewable_id, :ip_address
  json.url view_url(view, format: :json)
end
