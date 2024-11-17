class DataAccessRequest < ApplicationRecord
  belongs_to :fsp_user
  belongs_to :user

  STATUS_PENDING = 0
  STATUS_APPROVED = 1
  STATUS_REJECTED = 2

  before_create :set_default_status

  # Scopes for filtering by status
  scope :pending, -> { where(status: STATUS_PENDING) }
  scope :approved, -> { where(status: STATUS_APPROVED) }
  scope :rejected, -> { where(status: STATUS_REJECTED) }

  # Custom helper methods for status checks
  def pending?
    status == STATUS_PENDING
  end

  def approved?
    status == STATUS_APPROVED
  end

  def rejected?
    status == STATUS_REJECTED
  end

  # Method to get human-readable status label
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

  private

  def set_default_status
    self.status ||= STATUS_PENDING
  end
end
