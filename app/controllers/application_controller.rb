class ApplicationController < ActionController::Base
  impersonates :user
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout :layout_by_resource

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:business_name, :phone_number, :business_category, :role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar,:business_name, :phone_number, :business_category, :role ])
    end
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || main_app.root_path)
    end
    def layout_by_resource
      if devise_controller?
        "application" # This ensures that Devise uses the application layout
      else
        "application"
      end
    end
    
end
