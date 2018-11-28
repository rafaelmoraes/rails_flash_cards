# frozen_string_literal: true

require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  NUMERIC_ATTRS = %i[cards_per_review repeat_easy_card
    repeat_medium_card repeat_hard_card].freeze
  setup do
    @setting = settings(:always_valid)
  end

  test "visiting the index" do
    visit settings_url
    assert_selector "h1", text: t("index.title")

    I18n.available_locales.each do |locale|
      assert_selector "label", text: t(:"available_locales.#{locale}")
    end

    Setting::COLOR_SCHEMES.each do |name|
      assert_selector "label", text: t("form.color_schemes.#{name}")
    end

    NUMERIC_ATTRS.each do |attr_name|
      assert_selector "input[name='setting[#{attr_name}]']"
    end

    t_click_submit :update
  end

  test "should change the language" do
    visit settings_url
    old_locale = I18n.locale
    locales = I18n.available_locales.reject { |e| e == old_locale }
    locales.each do |new_locale|
      find("label", text: t(:"available_locales.#{new_locale}")).click
      t_click_submit :update
      assert_selector ":checked[value='#{new_locale}']", visible: false
      I18n.locale = new_locale
      t_assert_text "update.updated"
    end
  end

  test "should change the color scheme" do
    visit settings_url
    old_theme = find(":checked[name='setting[color_scheme]']", visible: false).value
    themes = Setting::COLOR_SCHEMES.reject { |e| e == old_theme }
    themes.each do |new_theme|
      find("label", text: t("form.color_schemes.#{new_theme}")).click
      t_click_submit :update
      assert_selector ":checked[value='#{new_theme}']", visible: false
      t_assert_text "update.updated"
    end
  end

  test "should change some numeric review parameter" do
    visit settings_url
    v = "9999"
    NUMERIC_ATTRS.each do |field_name|
      t_fill_in field_name, with: v
      t_click_submit :update
      assert_equal v, find("#setting_#{field_name}").value
    end
  end

  test "should show error messages" do
    visit settings_url
    t_fill_in NUMERIC_ATTRS.sample, with: nil
    t_click_submit :update
    assert_selector "#error_explanation"
  end
end
