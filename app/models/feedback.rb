class Feedback < ApplicationRecord
  CATEGORIES = %w[bug feature ui other].freeze

  enum :status, { open: "open", in_review: "in_review", resolved: "resolved" }

  validates :email, :category, :message, presence: true
  validates :status, inclusion: { in: statuses.keys }
end
