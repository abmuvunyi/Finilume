class Income < ApplicationRecord
  belongs_to :user

  validates :name, :amount, :category, :date, presence: true
  validates :user, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name category amount date created_at updated_at user_id]
  end
end
