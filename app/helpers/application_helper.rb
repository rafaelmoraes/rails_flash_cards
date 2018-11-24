# frozen_string_literal: true

# View helpers for all views
module ApplicationHelper
  def bool_to_yes_or_no(boolean)
    boolean ? t("yes") : t("no")
  end

  RadioButton = Struct.new(:value, :label)
  def available_locales_for_radio_buttons
    I18n.available_locales.map do |locale|
      RadioButton.new(locale, t("available_locales.#{locale}")).freeze
    end
  end
end
