class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dashboard_data, only: [:index, :download_pdf]

  def index
    # Total Revenue from Sales
    @total_revenue = current_user.sales.sum(:total_price)

    # Top-Selling Products (limit to top 5 products)
    @top_selling_products = current_user.products.joins(:sales)
                                                 .select('products.*, SUM(sales.quantity) AS total_sold')
                                                 .group('products.id')
                                                 .order('total_sold DESC')
                                                 .limit(5)

    # Low Stock Products (products with quantity < 5)
    @low_stock_products = current_user.products.where('quantity < ?', 5)

    # Total Expenses
    @total_expenses = current_user.expenses.sum(:amount)

    # Total Income
    @total_income = current_user.incomes.sum(:amount)

    # Net Profit (Total Income - Total Expenses)
    @net_profit = @total_income - @total_expenses

  end

  def download_pdf
    # Generate PDF using Prawn
    pdf = Prawn::Document.new
    pdf.text "Business Report", size: 24, style: :bold
    pdf.move_down 20

    # Adding Total Revenue, Expenses, Income, and Net Profit
    pdf.text "Summary", size: 20, style: :bold
    pdf.text "Total Revenue: RWF #{@total_revenue}", size: 16
    pdf.text "Total Expenses: RWF #{@total_expenses}", size: 16
    pdf.text "Total Income: RWF #{@total_income}", size: 16
    pdf.text "Net Profit: RWF #{@net_profit}", size: 16
    pdf.move_down 20

    # Adding All Products
    pdf.text "Products List", size: 18, style: :bold
    pdf.move_down 10
    if current_user.products.any?
      product_data = [["Name", "Category", "Price", "Quantity"]]
      current_user.products.each do |product|
        product_data << [product.name, product.category, "RWF #{product.price}", product.quantity]
      end
      pdf.table(product_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { borders: [:bottom] })
    else
      pdf.text "No products available."
    end
    pdf.move_down 20

    # Adding All Sales
    pdf.text "Sales List", size: 18, style: :bold
    pdf.move_down 10
    if current_user.sales.any?
      sales_data = [["Product", "Quantity", "Total Price", "Date"]]
      current_user.sales.each do |sale|
        sales_data << [sale.product.name, sale.quantity, "RWF #{sale.total_price}", sale.date.strftime("%Y-%m-%d")]
      end
      pdf.table(sales_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { borders: [:bottom] })
    else
      pdf.text "No sales available."
    end
    pdf.move_down 20

    # Adding All Income
    pdf.text "Income List", size: 18, style: :bold
    pdf.move_down 10
    if current_user.incomes.any?
      income_data = [["Name", "Category", "Amount", "Date"]]
      current_user.incomes.each do |income|
        income_data << [income.name, income.category, "RWF #{income.amount}", income.date.strftime("%Y-%m-%d")]
      end
      pdf.table(income_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { borders: [:bottom] })
    else
      pdf.text "No income records available."
    end
    pdf.move_down 20

    # Adding All Expenses
    pdf.text "Expenses List", size: 18, style: :bold
    pdf.move_down 10
    if current_user.expenses.any?
      expenses_data = [["Name", "Category", "Amount", "Date"]]
      current_user.expenses.each do |expense|
        expenses_data << [expense.name, expense.category, "RWF #{expense.amount}", expense.date.strftime("%Y-%m-%d")]
      end
      pdf.table(expenses_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { borders: [:bottom] })
    else
      pdf.text "No expense records available."
    end

    # Send PDF as a downloadable file
    send_data pdf.render, filename: "business_report.pdf", type: "application/pdf", disposition: "attachment"
  end

  private

  def set_dashboard_data
    @total_revenue = current_user.sales.sum(:total_price)
    @top_selling_products = current_user.products.joins(:sales)
                                                 .select('products.*, SUM(sales.quantity) AS total_sold')
                                                 .group('products.id')
                                                 .order('total_sold DESC')
                                                 .limit(5)
    @low_stock_products = current_user.products.where('quantity < ?', 5)
    @total_expenses = current_user.expenses.sum(:amount)
    @total_income = current_user.incomes.sum(:amount)
    @net_profit = @total_income - @total_expenses
  end

end
