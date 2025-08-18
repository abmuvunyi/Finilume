# app/helpers/dashboard_data_helper.rb
module DashboardDataHelper
  def build_dashboard_metrics(user)
    {
      total_revenue:  user.sales.sum(:total_price),
      total_expenses: user.expenses.sum(:amount),
      total_income:   user.incomes.sum(:amount),
      net_profit:     user.incomes.sum(:amount) - user.expenses.sum(:amount),
      low_stock_products: user.products.where('quantity < ?', 5),
      top_selling_products: user.products.joins(:sales)
                                          .select('products.*, SUM(sales.quantity) AS total_sold')
                                          .group('products.id')
                                          .order('total_sold DESC')
                                          .limit(5),
      products: user.products,
      sales:    user.sales,
      incomes:  user.incomes,
      expenses: user.expenses,
      revenue_by_month: user.sales.group_by_month(:date).sum(:total_price),
      expenses_by_month: user.expenses.group_by_month(:date).sum(:amount),
      income_vs_expense: {
        "Income" => user.incomes.sum(:amount),
        "Expenses" => user.expenses.sum(:amount)
      }
    }
  end
end
