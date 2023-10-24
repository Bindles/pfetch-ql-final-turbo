json.extract! product, :id, :name, :price, :entity_id, :created_at, :updated_at
json.url product_url(product, format: :json)
