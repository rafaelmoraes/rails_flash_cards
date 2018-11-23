# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :set_locale,
                :set_color_scheme_cookie
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_invitation_token, if: :sign_up?

  def self.default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    locale = current_setting.locale if current_setting
    I18n.locale = locale || params[:locale] || I18n.default_locale
  end

  def set_color_scheme_cookie
    cs = current_setting&.color_scheme || Setting.default_color_scheme
    cookies[:color_scheme] = cs if cookies[:color_scheme].nil? ||
                                   current_user && cookies[:color_scheme] != cs
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name invitation_token guest_name])
  end

  def current_setting
    current_user&.setting
  end

  def check_invitation_token
    return if Invitation.token_valid?(params[:invitation_token])
    raise ActionController::RoutingError, "Not Found"
  end

  def sign_up?
    params[:controller] == "devise/registrations" &&
    (params[:action] == "new" || params[:action] == "create")
  end
end
