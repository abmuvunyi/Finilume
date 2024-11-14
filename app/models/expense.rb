class Expense < ApplicationRecord
  belongs_to :user

  validates :name, :amount, :category, :date, presence: true
end
