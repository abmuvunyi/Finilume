class FspDashboardController < ApplicationController
    before_action :authenticate_fsp_user!
  
    def index
      # Fetch all users that have business information (business_name and business_category present)
      @users = User.where.not(business_category: [nil, ''])
    end
  
    def request_data_access
      # Allow the FSP user to request data access from a registered user
      @user = User.find(params[:id])
      DataAccessRequest.create(fsp_user: current_fsp_user, user: @user, status: 'pending')
  
      redirect_to fsp_dashboard_index_path, notice: 'Data access request sent successfully.'
    end
  end
  