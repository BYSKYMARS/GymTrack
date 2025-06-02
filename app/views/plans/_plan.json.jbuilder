json.extract! plan, :id, :name, :price, :duration, :description, :created_at, :updated_at
json.url plan_url(plan, format: :json)
