json.extract! place, :id, :name, :url, :created_at, :updated_at
json.url place_url(place, format: :json)
