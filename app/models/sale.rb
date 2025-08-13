class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_one    :income, dependent: :nullify

  # quantity:int, total_price:numeric (default 0), date:timestamp (nullable)
  # discount_amount:numeric (nullable or default 0)
  validates :product, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :discount_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate  :enough_stock, on: :create

  before_validation :compute_total_price_and_date
  after_commit      :apply_sale_effects, on: :create

  private

  def compute_total_price_and_date
    # Use product price and quantity to compute the gross
    unit_price = product&.price.to_d
    qty        = quantity.to_i
    discount   = (discount_amount.presence || 0).to_d

    gross = unit_price * qty
    self.total_price = [gross - discount, 0].max

    # If date not provided, set from "now" (created_at isn’t set yet here)
    self.date ||= Time.zone.now
  end

  def enough_stock
    return if product.blank?
    if product.quantity.to_i < quantity.to_i
      errors.add(:quantity, I18n.t("sales.errors.not_enough_stock", default: "Not enough stock"))
    end
  end

  def apply_sale_effects
    # Reduce stock (lock row to avoid race conditions)
    product.with_lock do
      product.update!(quantity: product.quantity.to_i - quantity.to_i)
    end

    # Create Income (category = "sales"), use sale date (to_date)
    attrs = {
      user_id:  user_id,
      name:     I18n.t("sales.income_name", default: "Sale of %{name}", name: product.name),
      amount:   total_price.to_d,
      category: "sales",
      date:     (date || created_at || Time.current).to_date
    }

    # Only attach sale_id if the column exists (works whether you added it or not)
    attrs[:sale_id] = id if Income.column_names.include?("sale_id")

    Income.create!(attrs)
  rescue => e
    Rails.logger.error("[Sale#apply_sale_effects] #{e.class}: #{e.message}")
  end

  # --- Ransack allow‑list ---
  def self.ransackable_attributes(_auth_object = nil)
    %w[id product_id quantity total_price user_id date created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[product user]
  end
  # --- end Ransack allow‑list ---
end
