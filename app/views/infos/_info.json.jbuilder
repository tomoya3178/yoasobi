json.extract! info, :id, :url, :title, :date, :place_id, :created_at, :updated_at
json.url info_url(info, format: :json)
