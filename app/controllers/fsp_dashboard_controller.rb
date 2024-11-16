
  class FspDashboardController < ApplicationController
    before_action :authenticate_fsp_user!
    before_action :check_approval, only: [:view_business]

    def index
      @users = User.where.not(business_name: [nil, ''])
    end

    def request_data_access
      user = User.find(params[:id])
      DataAccessRequest.create!(
        user: user,
        fsp_user: current_fsp_user,
        status: DataAccessRequest::STATUS_PENDING
      )
      redirect_to fsp_dashboard_index_path, notice: "Data access request has been sent."
    end

    def view_business
      @user = User.find(params[:id])
      @total_revenue = @user.sales.sum(:total_price)
      @total_expenses = @user.expenses.sum(:amount)
      @total_income = @user.incomes.sum(:amount)
      @net_profit = @total_income - @total_expenses
      @low_stock_products = @user.products.where('quantity < ?', 5)
      @top_selling_products = @user.products.joins(:sales)
                                            .select('products.*, SUM(sales.quantity) AS total_sold')
                                            .group('products.id')
                                            .order('total_sold DESC')
                                            .limit(5)
      @products = @user.products
      @sales = @user.sales
      @incomes = @user.incomes
      @expenses = @user.expenses
    end

    private

    def check_approval
      user = User.find(params[:id])
      data_request = DataAccessRequest.find_by(fsp_user: current_fsp_user, user: user)

      unless data_request&.approved?
        redirect_to fsp_dashboard_index_path, alert: "You are not authorized to view this data."
      end
    end
  end

