# frozen_string_literal: true

# Helpers for Setting views
module SettingsHelper
  RadioButton = Struct.new(:value, :label)

  def available_locales_for_radio_buttons
    I18n.available_locales.map do |locale|
      RadioButton.new(locale, t("available_locales.#{locale}")).freeze
    end
  end
end
