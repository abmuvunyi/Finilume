# This file ensures the existence of records required to run the application in every environment.
# The code is idempotent to safely execute in production, development, and test environments.
# Run with `bin/rails db:seed` or alongside `db:setup`.

# Create admin user if it doesn't exist
User.find_or_create_by(email: 'admin@finilume.com') do |user|
  user.first_name = "Abdallah"
  user.last_name = "Admin"
  user.phone_number = "0788998899"
  user.business_category = "Administration"
  user.password = ENV["ADMIN_PASSWORD"] || "123456"
  user.password_confirmation = ENV["ADMIN_PASSWORD"] || "123456"
  user.admin = true
end

# Create sample data only in development or test environments
if Rails.env.development? || Rails.env.test?
  # Create one sample user with business information
  user = User.find_or_create_by(email: 'example@example.com') do |u|
    u.first_name = "Jane"
    u.last_name = "Doe"
    u.password = "123456"
    u.password_confirmation = "123456"
    u.business_name = "John's Retail Shop"
    u.business_category = "Retail"
    u.phone_number = "123-456-7890"
  end

  # Create Products for the User
  5.times do |i|
    Product.find_or_create_by(name: "Product#{i + 1}", user: user) do |product|
      product.category = [ "Electronics", "Clothing", "Food", "Furniture", "Books" ].sample
      product.price = rand(10..100)
      product.quantity = rand(5..50)
    end
  end

  # Create Sales for the User (linked to existing products)
  5.times do
    product = user.products.sample
    quantity_sold = [ rand(1..5), product.quantity ].min # Prevent negative quantities
    total_price = product.price * quantity_sold
    date = Date.today - rand(1..10).days

    Sale.find_or_create_by(product: product, user: user, date: date, total_price: total_price) do |sale|
      sale.quantity = quantity_sold
      product.update(quantity: product.quantity - quantity_sold) unless sale.persisted? # Update only for new sales
    end
  end

  # Create Income Records for the User
  3.times do |i|
    Income.find_or_create_by(name: "Income Source #{i + 1}", user: user, date: Date.today - rand(1..30).days) do |income|
      income.amount = rand(1000..5000)
      income.category = [ "Sales", "Service", "Other" ].sample
    end
  end

  # Create Expense Records for the User
  3.times do |i|
    Expense.find_or_create_by(name: "Expense #{i + 1}", user: user, date: Date.today - rand(1..30).days) do |expense|
      expense.category = [ "Utilities", "Rent", "Supplies" ].sample
      expense.amount = rand(500..3000)
    end
  end

  puts "Sample data created successfully for #{Rails.env} environment"
end

puts "Seeds completed successfully"
