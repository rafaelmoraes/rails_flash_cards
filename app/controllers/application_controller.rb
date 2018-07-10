# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  def self.default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = current_user.try(:setting).try(:locale) ||
                  params[:locale] ||
                  I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
