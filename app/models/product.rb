class Product < ApplicationRecord
  belongs_to :user
  has_many :sales, dependent: :destroy

  validates :name, :price, :quantity, presence: true
end
