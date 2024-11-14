class ApplicationController < ActionController::Base
  impersonates :user
  include Pundit::Authorization

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:business_name, :phone_number, :business_category])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar,:business_name, :phone_number, :business_category])
    end
end
