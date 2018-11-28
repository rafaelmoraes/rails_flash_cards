# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  before_action :set_locale, :set_color_scheme_cookie

  default_form_builder MyApplicationFormBuilder

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

  def current_setting
    current_user&.setting
  end
end
