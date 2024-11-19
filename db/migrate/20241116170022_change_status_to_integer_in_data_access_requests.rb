class ChangeStatusToIntegerInDataAccessRequests < ActiveRecord::Migration[7.0]

  def change
    # Step 1: Remove the old status column
    remove_column :data_access_requests, :status, :string

    # Step 2: Add the new status column as an integer with a default value of 0
    add_column :data_access_requests, :status, :integer, default: 0, null: false
  end
end
