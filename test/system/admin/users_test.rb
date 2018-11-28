# frozen_string_literal: true

require "application_system_test_case"

class Admin::UsersTest < ApplicationSystemTestCase
  setup do
    @admin = users(:always_valid)
  end

  test "visiting the index" do
    visit admin_users_url
    assert_selector "h1", text: t("index.title")
    total_users = User.where(admin: false).count
    assert_equal total_users, all("a", text: t(:destroy)).size
  end

  test "destroying a User" do
    visit admin_users_url
    old_users_count = all("a", text: t(:destroy)).size
    page.accept_confirm do
      click_on t(:destroy), match: :first
    end
    t_assert_text "destroy.destroyed"
    assert_equal (old_users_count - 1), all("a", text: t(:destroy)).size
  end
end
