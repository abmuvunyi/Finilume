class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :user, presence: true

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :quantity_in_stock

  before_validation :set_total_price

  # Custom validation to ensure there is enough stock
  def quantity_in_stock
    if quantity.present? && product.present? && quantity > product.quantity
      errors.add(:quantity, "cannot be greater than available stock")
    end
  end

  # Method to set total price based on product price and quantity
  def set_total_price
    if product.present? && quantity.present?
      self.total_price = product.price * quantity
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[quantity total_price date created_at updated_at product_id user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product user]
  end
end
