class FspUsers::RegistrationsController < Devise::RegistrationsController
  layout 'application'
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  # Permit additional parameters during sign up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  # Permit additional parameters during account update
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end
end
