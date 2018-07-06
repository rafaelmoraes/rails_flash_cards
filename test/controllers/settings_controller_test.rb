# frozen_string_literal: true

require 'test_helper'

# Integration test to SettingsController
class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setting = settings(:one)
  end

  test 'should get edit' do
    get settings_url
    assert_response :success
  end

  test 'should update setting' do
    patch setting_url(@setting), params: {
      setting: {
        cards_per_review: @setting.cards_per_review,
        locale: @setting.locale,
        repeat_easy_card: @setting.repeat_easy_card,
        repeat_hard_card: @setting.repeat_hard_card,
        repeat_medium_card: @setting.repeat_medium_card
      }
    }
    assert_redirected_to settings_url(locale: @setting.locale)
  end
end
