json.extract! product, :id, :name, :category, :price, :quantity, :user_id, :created_at, :updated_at
json.url product_url(product, format: :json)
