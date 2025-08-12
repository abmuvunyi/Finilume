# db/seeds.rb
# Ensures the existence of records required to run the application in every environment.
# Safe (idempotent) to run multiple times in production, development, and test.

# -----------------------------
# Admin account (always present)
# -----------------------------
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@finilume.com")
admin_pass  = ENV.fetch("ADMIN_PASSWORD", "123456")

User.find_or_create_by(email: admin_email) do |user|
  user.first_name        = "Abdallah"
  user.last_name         = "Admin"
  user.phone_number      = "0788998899"
  user.business_category = "Administration"
  user.password          = admin_pass
  user.password_confirmation = admin_pass
  user.admin = true
end

puts "[seed] Admin ensured: #{admin_email}"

# ---------------------------------------------------
# Sample data only in development/test (skips if user exists)
# ---------------------------------------------------
if Rails.env.development? || Rails.env.test?
  tester_email = "tester@finilume.com"

  if User.exists?(email: tester_email)
    puts "[seed] Tester already exists (#{tester_email}) — skipping ALL sample data."
  else
    puts "[seed] Creating tester and sample data..."

    tester = User.create!(
      email: tester_email,
      first_name: "User",
      last_name: "Tester",
      password: "123456",
      password_confirmation: "123456",
      business_name: "Tester's Retail Shop",
      business_category: "Retail",
      phone_number: "0788997890"
    )

    # Create Products for the tester
    categories = %w[Electronics Clothing Food Furniture Books]
    5.times do |i|
      Product.find_or_create_by!(name: "Product#{i + 1}", user: tester) do |product|
        product.category = categories.sample
        product.price    = rand(10..100)
        product.quantity = rand(5..50)
      end
    end

    # Create Sales for the tester (linked to existing products)
    5.times do
      product = tester.products.order("RANDOM()").first
      next unless product

      quantity_sold = [rand(1..5), product.quantity].min
      next if quantity_sold <= 0

      date        = Date.today - rand(1..10).days
      total_price = product.price * quantity_sold

      Sale.find_or_create_by!(product: product, user: tester, date: date, total_price: total_price) do |sale|
        sale.quantity = quantity_sold
        # Reduce stock only on create
        product.update!(quantity: product.quantity - quantity_sold)
      end
    end

    # Create Income records for the tester
    %w[Sales Service Other].sample(3).each_with_index do |cat, i|
      Income.find_or_create_by!(name: "Income Source #{i + 1}", user: tester, date: Date.today - rand(1..30).days) do |income|
        income.amount   = rand(1000..5000)
        income.category = cat
      end
    end

    # Create Expense records for the tester
    %w[Utilities Rent Supplies].sample(3).each_with_index do |cat, i|
      Expense.find_or_create_by!(name: "Expense #{i + 1}", user: tester, date: Date.today - rand(1..30).days) do |expense|
        expense.category = cat
        expense.amount   = rand(500..3000)
      end
    end

    puts "[seed] Sample data created for tester (#{tester_email})."
  end
end

puts "[seed] Seeds completed successfully."
