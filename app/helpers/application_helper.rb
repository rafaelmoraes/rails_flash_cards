# frozen_string_literal: true

# View helpers for all views
module ApplicationHelper
  def yes_or_no(boolean)
    boolean ? t("yes") : t("no")
  end

  RadioButton = Struct.new(:value, :label)
  def available_locales_for_radio_buttons
    I18n.available_locales.map do |locale|
      RadioButton.new(locale, t("available_locales.#{locale}")).freeze
    end
  end
end

class MyApplicationFormBuilder < ActionView::Helpers::FormBuilder
  REQUIRED = !Rails.env.test?.freeze

  %i[email number password text].each do |name|
    define_method "required_#{name}_field" do |method, options = {}|
      options[:required] = REQUIRED
      send("#{name}_field", method, options)
    end
  end

  %i[text_area].each do |name|
    define_method "required_#{name}" do |method, options = {}|
      options[:required] = REQUIRED
      send("#{name}", method, options)
    end
  end
end
