# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Clear existing data to avoid duplicates


# Create one sample user with business information
user = User.create!(
  first_name: "John",
  last_name: "Doe",
  email: "example1@example.com",
  password: "123456",
  password_confirmation: "123456",
  business_name: "John's Retail Shop",
  business_category: "Retail",
  phone_number: "123-456-7890"
)

# Create Products for the User
5.times do |i|
  Product.create!(
    name: "Product#{i + 1}",
    category: ["Electronics", "Clothing", "Food", "Furniture", "Books"].sample,
    price: rand(10..100),  # Random price between 10 and 100
    quantity: rand(5..50),  # Random quantity between 5 and 50
    user: user
  )
end

# Create Sales for the User (linked to existing products)
5.times do
  product = user.products.sample
  quantity_sold = rand(1..5)

  Sale.create!(
    product: product,
    quantity: quantity_sold,
    total_price: product.price * quantity_sold,
    user: user,
    date: Date.today - rand(1..10).days  # Random date within the last 10 days
  )

  # Decrease product quantity after sale
  product.update(quantity: product.quantity - quantity_sold)
end

# Create Income Records for the User
3.times do |i|
  Income.create!(
    name: "Income Source #{i + 1}", # Changed 'source' to 'name'
    amount: rand(1000..5000),  # Random income between 1000 and 5000
    category: ["Sales", "Service", "Other"].sample, # Added category since the schema has it
    date: Date.today - rand(1..30).days,
    user: user
  )
end

# Create Expense Records for the User
3.times do |i|
  Expense.create!(
    category: ["Utilities", "Rent", "Supplies"].sample,
    amount: rand(500..3000),  # Random expense between 500 and 3000
    date: Date.today - rand(1..30).days,
    user: user
  )
end

puts "Created one sample user with products, sales, income, and expenses."
