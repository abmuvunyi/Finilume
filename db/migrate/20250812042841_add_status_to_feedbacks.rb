class AddStatusToFeedbacks < ActiveRecord::Migration[7.1]
  def up
    unless column_exists?(:feedbacks, :status)
      add_column :feedbacks, :status, :string, null: false, default: "open"
    else
      # Make sure the constraints are what we expect
      change_column_default :feedbacks, :status, "open"
      change_column_null :feedbacks, :status, false
    end
  end

  def down
    # Only remove if present (keeps rollback safe)
    remove_column :feedbacks, :status if column_exists?(:feedbacks, :status)
  end
end
