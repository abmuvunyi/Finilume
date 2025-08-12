class AddStatusToFeedbacks < ActiveRecord::Migration[7.2]
  def change
    add_column :feedbacks, :status, :string, null: false, default: "open"
  end
end

