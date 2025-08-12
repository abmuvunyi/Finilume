# db/migrate/20250812042841_add_status_to_feedbacks.rb
class AddStatusToFeedbacks < ActiveRecord::Migration[7.1]
  def up
    if !column_exists?(:feedbacks, :status)
      add_column :feedbacks, :status, :string, null: false, default: "open"
    else
      # Enforce expected constraints if column is already present
      change_column_default :feedbacks, :status, "open"
      change_column_null :feedbacks, :status, false
    end
  end

  def down
    remove_column :feedbacks, :status if column_exists?(:feedbacks, :status)
  end
end
