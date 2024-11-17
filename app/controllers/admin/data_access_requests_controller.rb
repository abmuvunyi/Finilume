module Admin
  class DataAccessRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def index
      @data_access_requests = DataAccessRequest.pending.includes(:user, :fsp_user).reload

    end

    def update
      data_access_request = DataAccessRequest.find(params[:id])
      if params[:approve] == "true"
        if data_access_request.update(status: DataAccessRequest::STATUS_APPROVED)
          Rails.logger.info "DataAccessRequest #{data_access_request.id} approved successfully."
          redirect_to admin_data_access_requests_path, notice: "Data access request approved."
        else
          Rails.logger.error "Failed to approve DataAccessRequest #{data_access_request.id}: #{data_access_request.errors.full_messages}"
          redirect_to admin_data_access_requests_path, alert: "Unable to approve request."
        end
      else
        if data_access_request.update(status: DataAccessRequest::STATUS_REJECTED)
          Rails.logger.info "DataAccessRequest #{data_access_request.id} rejected successfully."
          redirect_to admin_data_access_requests_path, alert: "Data access request rejected."
        else
          Rails.logger.error "Failed to reject DataAccessRequest #{data_access_request.id}: #{data_access_request.errors.full_messages}"
          redirect_to admin_data_access_requests_path, alert: "Unable to reject request."
        end
      end
    end
    

    private

    def ensure_admin!
      redirect_to root_path, alert: "You are not authorized to access this section." unless current_user.admin?
    end
  end
end
