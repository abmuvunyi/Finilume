json.extract! expense, :id, :name, :amount, :category, :date, :user_id, :created_at, :updated_at
json.url expense_url(expense, format: :json)
