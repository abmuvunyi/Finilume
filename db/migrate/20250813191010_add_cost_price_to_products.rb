# db/migrate/2025xxxxxx_add_cost_price_to_products.rb
class AddCostPriceToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :cost_price, :decimal, precision: 12, scale: 2, null: false, default: 0
    add_index  :products, :cost_price
  end
end
