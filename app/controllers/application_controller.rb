# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def self.default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    locale = current_user.setting.locale if current_user&.setting
    I18n.locale = locale || params[:locale] || I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
