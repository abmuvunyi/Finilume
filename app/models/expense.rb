class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :product, optional: true

  before_validation :default_date
  before_validation :default_category_for_product

  private

  def default_date
    self.date ||= (created_at || Time.current).to_date
  end

  def default_category_for_product
    self.category ||= "product_purchase" if product_id.present?
  end
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name amount category date user_id created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end
end
