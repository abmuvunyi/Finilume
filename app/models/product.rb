class Product < ApplicationRecord
  belongs_to :user
  has_many   :sales, dependent: :restrict_with_exception
  has_many   :expenses, dependent: :nullify, foreign_key: :product_id, inverse_of: :product

  validates :name, presence: true
  validates :price,       numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :cost_price,  numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :quantity,    numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # --- Expense creation hooks ---
  after_commit :record_initial_stock_expense, on: :create
  after_commit :record_added_stock_expense,   on: :update

  # ===== Helpers =====
  def record_initial_stock_expense
    q  = quantity.to_i
    cp = cost_price.to_d
    return if q <= 0 || cp <= 0

    Rails.logger.info("[Product##{id}] initial stock expense -> q=#{q}, cp=#{cp}, amount=#{cp * q}")

    Expense.create!(
      user_id:    user_id,
      product_id: id,
      name: I18n.t("products.expense.initial_stock_name",
             default: "Initial stock for %{name}", name: name),
      amount:     cp * q,
      category:   "product_purchase",
      date:       (created_at || Time.current).to_date
    )
  rescue => e
    Rails.logger.error("[Product#record_initial_stock_expense] #{e.class}: #{e.message}")
  end

  def record_added_stock_expense
    # Only when quantity actually changed AND increased
    return unless saved_change_to_quantity?

    before_q = quantity_before_last_save.to_i
    after_q  = quantity.to_i
    added    = after_q - before_q
    cp       = cost_price.to_d

    Rails.logger.info("[Product##{id}] quantity change: #{before_q} -> #{after_q} (added=#{added}), cp=#{cp}")

    return if added <= 0 || cp <= 0

    Rails.logger.info("[Product##{id}] added stock expense -> added=#{added}, cp=#{cp}, amount=#{cp * added}")

    Expense.create!(
      user_id:    user_id,
      product_id: id,
      name: I18n.t("products.expense.added_stock_name",
             default: "Added stock for %{name}", name: name),
      amount:     cp * added,
      category:   "product_purchase",
      date:       (updated_at || Time.current).to_date
    )
  rescue => e
    Rails.logger.error("[Product#record_added_stock_expense] #{e.class}: #{e.message}")
  end

  # --- Ransack allow‑list ---
  def self.ransackable_attributes(_ = nil)
    %w[id name category price cost_price quantity user_id created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[sales user expenses]
  end
end
