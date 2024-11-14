class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user

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
end
