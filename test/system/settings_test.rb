require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    @setting = settings(:one)
  end

  test "visiting the index" do
    visit settings_url
    assert_selector "h1", text: "Settings"
  end

  test "creating a Setting" do
    visit settings_url
    click_on "New Setting"

    fill_in "Cards Per Session", with: @setting.cards_per_session
    fill_in "Locale", with: @setting.locale
    fill_in "Repeat Easy Card", with: @setting.repeat_easy_card
    fill_in "Repeat Hard Card", with: @setting.repeat_hard_card
    fill_in "Repeat Medium Card", with: @setting.repeat_medium_card
    click_on "Create Setting"

    assert_text "Setting was successfully created"
    click_on "Back"
  end

  test "updating a Setting" do
    visit settings_url
    click_on "Edit", match: :first

    fill_in "Cards Per Session", with: @setting.cards_per_session
    fill_in "Locale", with: @setting.locale
    fill_in "Repeat Easy Card", with: @setting.repeat_easy_card
    fill_in "Repeat Hard Card", with: @setting.repeat_hard_card
    fill_in "Repeat Medium Card", with: @setting.repeat_medium_card
    click_on "Update Setting"

    assert_text "Setting was successfully updated"
    click_on "Back"
  end

  test "destroying a Setting" do
    visit settings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Setting was successfully destroyed"
  end
end
