# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_range        # << new: builds @range_start, @range_end, @tz, @quick
  before_action :set_dashboard_data, only: [ :index, :download_pdf ]

  def index
    # ----- Ransack: keep your existing search behavior (unfiltered by date) -----
    @q_products = current_user.products.ransack(params[:q_products])
    @products   = @q_products.result(distinct: true)
                             .page(params[:products_page]).per(10)

    @q_sales = current_user.sales.includes(:product).ransack(params[:q_sales])
    @sales   = @q_sales.result(distinct: true)
                       .order(date: :desc)
                       .page(params[:sales_page]).per(10)

    @q_incomes = current_user.incomes.ransack(params[:q_incomes])
    @incomes   = @q_incomes.result(distinct: true)
                           .order(date: :desc)
                           .page(params[:incomes_page]).per(10)

    @q_expenses = current_user.expenses.ransack(params[:q_expenses])
    @expenses   = @q_expenses.result(distinct: true)
                             .order(date: :desc)
                             .page(params[:expenses_page]).per(10)
  end


  def download_pdf
    # IMPORTANT: reuse the same @*_in_range values already computed in set_dashboard_data
    pdf = Prawn::Document.new
    pdf.text "Business Report (#{@range_start.to_date} to #{@range_end.to_date})", size: 18, style: :bold
    pdf.move_down 10
  
    # Summary (Selected Range)
    pdf.text "Summary (Selected Range)", size: 14, style: :bold
    pdf.text "Revenue:      RWF #{@revenue_in_range.to_i}"
    pdf.text "Discounts:    RWF #{@discounts_in_range.to_i}"
    pdf.text "COGS:         RWF #{@cogs_in_range.to_i}"
    pdf.text "Gross Margin: RWF #{@gross_margin_in_range.to_i}"
    pdf.text "Expenses:     RWF #{@expenses_in_range.to_i}"
    pdf.text "Avg Order:    RWF #{@avg_order_value_in_range.to_i}"
    pdf.text "Net Profit:   RWF #{@net_profit_in_range.to_i}"
    pdf.move_down 15
  
    # Products (Selected Range)
    pdf.text "Products List", size: 13, style: :bold
    pdf.move_down 5
    if current_user.products.any?
      product_data = [ [ "Name", "Category", "Price", "Quantity" ] ]
      current_user.products.find_each do |product|
        product_data << [ product.name, product.category, "RWF #{product.price}", product.quantity ]
      end
      pdf.table(product_data, header: true, row_colors: [ "F0F0F0", "FFFFFF" ], cell_style: { borders: [ :bottom ] })
    else
      pdf.text "No products available."
    end
    pdf.move_down 10
  
    # Sales (Selected Range)
    pdf.text "Sales (#{@range_start.to_date} to #{@range_end.to_date})", size: 13, style: :bold
    pdf.move_down 5
    sales_in_range = current_user.sales.where(date: @range_start..@range_end).includes(:product)
    if sales_in_range.any?
      sales_data = [ [ "Product", "Quantity", "Total Price", "Discount", "Date" ] ]
      sales_in_range.find_each do |sale|
        sales_data << [
          sale.product&.name,
          sale.quantity,
          "RWF #{sale.total_price}",
          "RWF #{sale.discount_amount}",
          sale.date.strftime("%Y-%m-%d")
        ]
      end
      pdf.table(sales_data, header: true, row_colors: [ "F0F0F0", "FFFFFF" ], cell_style: { borders: [ :bottom ] })
    else
      pdf.text "No sales in selected range."
    end
    pdf.move_down 10
  
    # Incomes (Selected Range)
    pdf.text "Income (#{@range_start.to_date} to #{@range_end.to_date})", size: 13, style: :bold
    pdf.move_down 5
    incomes_in_range = current_user.incomes.where(date: @range_start..@range_end)
    if incomes_in_range.any?
      income_data = [ [ "Name", "Category", "Amount", "Date" ] ]
      incomes_in_range.find_each do |income|
        income_data << [ income.name, income.category, "RWF #{income.amount}", income.date.strftime("%Y-%m-%d") ]
      end
      pdf.table(income_data, header: true, row_colors: [ "F0F0F0", "FFFFFF" ], cell_style: { borders: [ :bottom ] })
    else
      pdf.text "No income in selected range."
    end
    pdf.move_down 10
  
    # Expenses (Selected Range)
    pdf.text "Expenses (#{@range_start.to_date} to #{@range_end.to_date})", size: 13, style: :bold
    pdf.move_down 5
    expenses_in_range = current_user.expenses.where(date: @range_start..@range_end)
    if expenses_in_range.any?
      expenses_data = [ [ "Name", "Category", "Amount", "Date" ] ]
      expenses_in_range.find_each do |expense|
        expenses_data << [ expense.name, expense.category, "RWF #{expense.amount}", expense.date.strftime("%Y-%m-%d") ]
      end
      pdf.table(expenses_data, header: true, row_colors: [ "F0F0F0", "FFFFFF" ], cell_style: { borders: [ :bottom ] })
    else
      pdf.text "No expenses in selected range."
    end
  
    send_data pdf.render,
              filename: "business_report_#{@range_start.to_date}_to_#{@range_end.to_date}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end
  

  private

  # -------------------
  # Date Range Handling
  # -------------------
  def set_range
    @tz = ActiveSupport::TimeZone["Africa/Kigali"] || Time.zone

    # Quick presets: today | this_week | mtd | last_30
    @quick = params[:quick].presence

    start_param = params[:start_date].presence
    end_param   = params[:end_date].presence

    if @quick.present?
      case @quick
      when "today"
        @range_start = @tz.now.beginning_of_day
        @range_end   = @tz.now.end_of_day
      when "this_week"
        @range_start = @tz.now.beginning_of_week
        @range_end   = @tz.now.end_of_week
      when "last_30"
        @range_end   = @tz.now.end_of_day
        @range_start = (@range_end - 29.days).beginning_of_day
      else # "mtd" or unknown → default MTD
        @range_start = @tz.now.beginning_of_month
        @range_end   = @tz.now.end_of_day
      end
    elsif start_param && end_param
      @range_start = @tz.parse(start_param).beginning_of_day
      @range_end   = @tz.parse(end_param).end_of_day
    else
      # Default: Month to date
      @range_start = @tz.now.beginning_of_month
      @range_end   = @tz.now.end_of_day
      @quick       = "mtd"
    end
  rescue => e
    Rails.logger.warn("[Dashboard#set_range] #{e.class}: #{e.message} — falling back to MTD")
    @range_start = @tz.now.beginning_of_month
    @range_end   = @tz.now.end_of_day
    @quick       = "mtd"
  end

  # -------------------------
  # KPI & Insight Computation
  # -------------------------
  def set_dashboard_data
    # Base relations (scoped to current_user and selected range built in set_range)
    sales_in_range    = current_user.sales.where(date: @range_start..@range_end).includes(:product)
    expenses_in_range = current_user.expenses.where(date: @range_start..@range_end)
    incomes_in_range  = current_user.incomes.where(date: @range_start..@range_end)

    # Revenue / discounts
    @revenue_in_range   = sales_in_range.sum(:total_price)
    @discounts_in_range = sales_in_range.sum(:discount_amount)

    # COGS & Gross Margin (cost_price * quantity)
    @cogs_in_range = sales_in_range.joins(:product).sum("sales.quantity * COALESCE(products.cost_price, 0)")
    @gross_margin_in_range = @revenue_in_range - @cogs_in_range

    # Orders & AOV
    @orders_in_range           = sales_in_range.count
    @avg_order_value_in_range  = @orders_in_range.positive? ? (@revenue_in_range / @orders_in_range) : 0

    # Expenses & Net profit
    @expenses_in_range   = expenses_in_range.sum(:amount)
    @net_profit_in_range = @gross_margin_in_range - @expenses_in_range

    # --------- Trends (line/column) ----------
    @daily_revenue   = sales_in_range.group_by_day(:date, time_zone: @tz.name).sum(:total_price)
    @daily_expenses  = expenses_in_range.group_by_day(:date, time_zone: @tz.name).sum(:amount)
    @daily_cogs      = sales_in_range.joins(:product)
                                     .group_by_day(:date, time_zone: @tz.name)
                                     .sum("sales.quantity * COALESCE(products.cost_price, 0)")

    # --------- Sparklines (last 14 days, always computed so KPIs show mini trend) ----------
    spark_end   = @tz.today
    spark_start = spark_end - 13.days
    sales_14d    = current_user.sales.where(date: spark_start.beginning_of_day..spark_end.end_of_day).includes(:product)
    expenses_14d = current_user.expenses.where(date: spark_start.beginning_of_day..spark_end.end_of_day)

    @spark_revenue_14d  = sales_14d.group_by_day(:date, time_zone: @tz.name).sum(:total_price)
    @spark_expenses_14d = expenses_14d.group_by_day(:date, time_zone: @tz.name).sum(:amount)
    @spark_cogs_14d     = sales_14d.joins(:product)
                                   .group_by_day(:date, time_zone: @tz.name)
                                   .sum("sales.quantity * COALESCE(products.cost_price, 0)")
    # gross margin spark = revenue - cogs (Chartkick can do stacking, but we’ll precompute for clarity)
    @spark_margin_14d = {}
    (@spark_revenue_14d.keys | @spark_cogs_14d.keys).sort.each do |d|
      @spark_margin_14d[d] = (@spark_revenue_14d[d] || 0) - (@spark_cogs_14d[d] || 0)
    end

    # --------- Top Products (bar chart) ----------
    @top_products_by_revenue = sales_in_range
      .joins(:product)
      .group("products.id", "products.name")
      .order(Arel.sql("SUM(sales.total_price) DESC"))
      .limit(5)
      .sum(:total_price) # => { [id,name] => revenue }

    # --------- Revenue by Category (pie) ----------
    @revenue_by_category = sales_in_range
      .joins(:product)
      .group("COALESCE(products.category, 'Uncategorized')")
      .sum(:total_price) # => { "Category" => revenue }

    # --------- Income vs Expenses (donut) ----------
    @income_vs_expenses = {
      I18n.t("dashboard.pie.income", default: "Income")   => incomes_in_range.sum(:amount),
      I18n.t("dashboard.pie.expenses", default: "Expenses") => @expenses_in_range
    }

    # --------- MTD vs Previous MTD comparison ----------
    mtd_start      = @tz.now.beginning_of_month
    prev_mtd_end   = (mtd_start - 1.day).end_of_day
    prev_mtd_start = prev_mtd_end.beginning_of_month

    mtd_sales       = current_user.sales.where(date: mtd_start..@tz.now.end_of_day)
    prev_mtd_sales  = current_user.sales.where(date: prev_mtd_start..prev_mtd_end)

    @mtd_revenue        = mtd_sales.sum(:total_price)
    @prev_mtd_revenue   = prev_mtd_sales.sum(:total_price)
    @mtd_revenue_change_pct = if @prev_mtd_revenue.to_d.zero?
                                 nil
    else
                                 ((@mtd_revenue - @prev_mtd_revenue) / @prev_mtd_revenue.to_d * 100).round(1)
    end

    # Keep your existing quantity-based list & low stock
    @top_selling_products = current_user.products.joins(:sales)
                                                 .select("products.*, SUM(sales.quantity) AS total_sold")
                                                 .group("products.id")
                                                 .order("total_sold DESC")
                                                 .limit(5)
    @low_stock_products = current_user.products.where("quantity < ?", 5)
  end
end
