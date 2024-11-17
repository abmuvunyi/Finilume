class ChangeTotalPriceInSales < ActiveRecord::Migration[8.0]
  def change
    change_column :sales, :total_price, :decimal, default: 0.0, null: false
  end
end
