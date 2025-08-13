class Income < ApplicationRecord
  belongs_to :user
  # This is safe even if the sale_id column doesn’t exist; Rails will ignore the association in queries
  # but if you prefer, you can guard it:
  # belongs_to :sale, optional: true if column_names.include?("sale_id")
  belongs_to :sale, optional: true

  # Set date from timestamp if not provided
  before_validation :default_date

  private

  def default_date
    self.date ||= (created_at || Time.current).to_date
  end

  # --- Ransack allow‑list ---
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name amount category date user_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end
  # --- end Ransack allow‑list ---
end
