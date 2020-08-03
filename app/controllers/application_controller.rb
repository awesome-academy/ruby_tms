class ApplicationController < ActionController::Base
  include CoursesHelper

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    {locale: I18n.locale}
  end

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.json{head :forbidden, content_type: "text/html"}
      format.html{redirect_to main_app.root_url, notice: t "application.not_permit"}
      format.json{head :forbidden, content_type: "text/html"}
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    flash[:danger] = t "application.not_found_resource"
    redirect_to root_url
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "application.logged_in_user.must_be_login"
    redirect_to log_in_url
  end

  def is_trainer?
    return if current_user.trainer?

    flash[:danger] = t "application.is_trainer.not_permit"
    redirect_to root_path
  end
end
