module Admin
  class DataAccessRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!

    def index
      @data_access_requests = DataAccessRequest.pending.includes(:user, :fsp_user)
    end

    def update
      data_access_request = DataAccessRequest.find(params[:id])
      if params[:approve] == "true"
        data_access_request.update(status: DataAccessRequest::STATUS_APPROVED)
        redirect_to admin_data_access_requests_path, notice: "Data access request approved."
      else
        data_access_request.update(status: DataAccessRequest::STATUS_REJECTED)
        redirect_to admin_data_access_requests_path, alert: "Data access request rejected."
      end
    end

    private

    def ensure_admin!
      redirect_to root_path, alert: "You are not authorized to access this section." unless current_user.admin?
    end
  end
end
