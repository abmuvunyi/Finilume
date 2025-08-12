class AddFieldsToFeedbacks < ActiveRecord::Migration[7.2]
  def change
    add_column :feedbacks, :email,    :string, null: false
    add_column :feedbacks, :category, :string, null: false
    add_column :feedbacks, :message,  :text,   null: false
  end
end

