# db/migrate/2025xxxxxx_add_discount_amount_to_sales.rb
class AddDiscountAmountToSales < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :discount_amount, :decimal, precision: 12, scale: 2, null: false, default: 0
    add_index  :sales, :discount_amount
  end
end
