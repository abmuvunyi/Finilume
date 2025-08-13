# db/migrate/2025xxxxxx_add_links_to_incomes_and_expenses.rb
class AddLinksToIncomesAndExpenses < ActiveRecord::Migration[7.2]
  def change
    add_reference :incomes,  :sale,    foreign_key: true, index: true, null: true
    add_reference :expenses, :product, foreign_key: true, index: true, null: true
  end
end
