class AddDefaultValueToDataAccessRequestStatus < ActiveRecord::Migration[8.0]
  def change
    change_column_default :data_access_requests, :status, from: nil, to: 0
  end
end
# Update any existing records with nil status to default status value 'pending'

