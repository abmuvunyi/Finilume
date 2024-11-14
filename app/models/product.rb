class Product < ApplicationRecord
  belongs_to :user
  has_many :sales, dependent: :destroy

  validates :name, :price, :quantity, presence: true
  def self.ransackable_attributes(auth_object = nil)
    %w[name category price quantity created_at updated_at]
  end
end
