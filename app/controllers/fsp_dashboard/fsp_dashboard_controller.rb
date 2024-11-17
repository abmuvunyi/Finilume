module FspDashboard
  class FspDashboardController < ApplicationController
    before_action :authenticate_fsp_user!
    before_action :check_approval, only: [:view_business]

    def index
      @users = User.where.not(business_name: [nil, ''])
      @data_access_requests = DataAccessRequest.where(fsp_user: current_fsp_user)
      
    end

#     def request_data_access
#   Rails.logger.debug "Request Data Access triggered for user: #{params[:id]}"
  
#   user = User.find(params[:id])
#   data_access_request = DataAccessRequest.create!(
#     user: user,
#     fsp_user: current_fsp_user,
#     status: DataAccessRequest::STATUS_PENDING
#   )
  
#   if data_access_request.persisted?
#     Rails.logger.debug "Data Access Request successfully created: #{data_access_request.inspect}"
#   else
#     Rails.logger.debug "Failed to create Data Access Request: #{data_access_request.errors.full_messages}"
#   end

#   redirect_to authenticated_fsp_root_path, notice: "Data access request has been sent."
# end
def request_data_access
  Rails.logger.debug "Request Data Access triggered for user: #{params[:id]}"
  user = User.find(params[:id])
  data_access_request = DataAccessRequest.create!(
    user: user,
    fsp_user: current_fsp_user,
    status: DataAccessRequest::STATUS_PENDING
  )
  Rails.logger.debug "DataAccessRequest: #{data_access_request.inspect}" if data_access_request.persisted?
  redirect_to authenticated_fsp_root_path, notice: "Data access request has been sent."
end


    

    def view_business
      @user = User.find(params[:id])
      # Business data calculations
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
        redirect_to authenticated_fsp_root_path, alert: "You are not authorized to view this data."
      end
    end
  end
end
