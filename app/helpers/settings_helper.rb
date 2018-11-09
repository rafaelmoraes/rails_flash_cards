# frozen_string_literal: true

# Helpers for Setting views
module SettingsHelper
  RadioButton = Struct.new(:value, :label)

  def available_locales_for_radio_buttons
    I18n.available_locales.map do |locale|
      RadioButton.new(locale, t("available_locales.#{locale}")).freeze
    end
  end

  def available_color_schemes_for_radio_buttons
    Setting::COLOR_SCHEMES.map do |color_scheme|
      RadioButton.new(color_scheme, t(".color_schemes.#{color_scheme}")).freeze
    end
  end
end
