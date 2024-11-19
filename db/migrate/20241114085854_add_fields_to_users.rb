class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :business_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :business_category, :string
  end
end
