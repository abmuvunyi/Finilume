class ApplicationController < ActionController::Base
  impersonates :user
  include Devise::Controllers::Helpers
  include Pundit::Authorization

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  # 🔐 Devise strong params for extra fields
  def configure_permitted_parameters
    added_attrs = [
      :first_name,
      :last_name,
      :business_name,
      :phone_number,
      :business_category,
      :email,
      :password,
      :password_confirmation
    ]

    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  # 🌐 Handle unauthorized access
  def user_not_authorized
    flash[:alert] = t("unauthorized", default: "You are not authorized to perform this action.")
    redirect_to(request.referrer || main_app.root_path)
  end

  # 🌍 Locale management
  def set_locale
    if params[:locale].present? && I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]
      session[:locale] = params[:locale]
    elsif session[:locale].present?
      I18n.locale = session[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  # 🌐 Ensure generated URLs include locale
  def default_url_options
    { locale: I18n.locale }
  end
end
