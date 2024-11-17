json.extract! sale, :id, :product_id, :quantity, :total_price, :user_id, :date, :created_at, :updated_at
json.url sale_url(sale, format: :json)
