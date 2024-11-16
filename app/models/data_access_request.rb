class DataAccessRequest < ApplicationRecord
  belongs_to :fsp_user
  belongs_to :user

   # Define constants for status
   STATUS_PENDING = 0
   STATUS_APPROVED = 1
   STATUS_REJECTED = 2
 
   # Scope to filter requests by status
   scope :pending, -> { where(status: STATUS_PENDING) }
   scope :approved, -> { where(status: STATUS_APPROVED) }
   scope :rejected, -> { where(status: STATUS_REJECTED) }
 
   # Method to get human-readable status
   def status_label
     case status
     when STATUS_PENDING
       "Pending"
     when STATUS_APPROVED
       "Approved"
     when STATUS_REJECTED
       "Rejected"
     else
       "Unknown"
     end
   end

end
