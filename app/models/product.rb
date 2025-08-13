class Product < ApplicationRecord
  belongs_to :user
  has_many :sales, dependent: :restrict_with_error
  has_many :expenses, dependent: :nullify

  # Ensure numeric presence (optional; adjust to your app’s style)
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }

  # Record expense for initial stock on create
  after_commit :record_initial_stock_expense, on: :create
  # Record expense when stock increases
  after_update :record_added_stock_expense, if: :saved_change_to_quantity?

  private

  def record_initial_stock_expense
    qty = quantity.to_i
    return if qty <= 0 || cost_price.to_d <= 0

    expenses.create!(
      user_id:   user_id,
      name:      I18n.t("products.initial_stock_expense", default: "Initial stock purchase for %{name}", name: name),
      amount:    (cost_price.to_d * qty),
      category:  "product_purchase",
      date:      (respond_to?(:created_at) ? created_at.to_date : Date.current)
    )
  rescue => e
    Rails.logger.error("[Products#record_initial_stock_expense] #{e.class}: #{e.message}")
  end

  def record_added_stock_expense
    before_qty, after_qty = saved_change_to_quantity
    delta = after_qty.to_i - before_qty.to_i
    return if delta <= 0 || cost_price.to_d <= 0

    expenses.create!(
      user_id:   user_id,
      name:      I18n.t("products.added_stock_expense", default: "Added stock for %{name}", name: name),
      amount:    (cost_price.to_d * delta),
      category:  "product_purchase",
      date:      Date.current
    )
  rescue => e
    Rails.logger.error("[Products#record_added_stock_expense] #{e.class}: #{e.message}")
  end
    # --- Ransack allow‑list (ADD this block near the bottom of the class) ---
    def self.ransackable_attributes(_auth_object = nil)
      %w[id name category price cost_price quantity user_id created_at updated_at]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[sales user]
    end
  # --- end Ransack allow‑list ---
end
