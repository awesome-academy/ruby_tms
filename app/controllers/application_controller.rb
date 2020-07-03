class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
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
end
