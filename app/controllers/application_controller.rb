# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  impersonates :user
  include Devise::Controllers::Helpers
  include Pundit::Authorization

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    added_attrs = %i[
      first_name last_name business_name phone_number business_category
      email password password_confirmation
    ]
    devise_parameter_sanitizer.permit(:sign_up,        keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def user_not_authorized
    flash[:alert] = t("unauthorized", default: "You are not authorized to perform this action.")
    redirect_to(request.referrer || main_app.root_path)
  end

  # Locale selection: URL param > session > default (I18n.default_locale)
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

  # Ensure helpers generate /<locale>/... links for the public app,
  # but DO NOT inject :locale for admin engine routes.
  def default_url_options
    # Skip locale for Madmin requests (path or controller namespace)
    if request&.path&.start_with?("/madmin") || params[:controller]&.start_with?("madmin/")
      {}
    else
      { locale: I18n.locale }
    end
  end
end
