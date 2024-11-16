class FspDashboardController < ApplicationController
    before_action :authenticate_fsp_user!
  
    def index
      # Fetch all users that have business information (business_name and business_category present)
      @users = User.where.not(business_category: [nil, ''])
    end
  
    def request_data_access
      user = User.find(params[:id])
      DataAccessRequest.create!(
        user: user,
        fsp_user: current_fsp_user,
        status: DataAccessRequest::STATUS_PENDING # Set status explicitly
      )
      redirect_to fsp_dashboard_index_path, notice: "Data access request has been sent."
    end
  end
  