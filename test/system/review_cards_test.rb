require "application_system_test_case"

class ReviewCardsTest < ApplicationSystemTestCase
  setup do
    @review_card = review_cards(:one)
  end

  test "visiting the index" do
    visit review_cards_url
    assert_selector "h1", text: "Review Cards"
  end

  test "creating a Review card" do
    visit review_cards_url
    click_on "New Review Card"

    click_on "Create Review card"

    assert_text "Review card was successfully created"
    click_on "Back"
  end

  test "updating a Review card" do
    visit review_cards_url
    click_on "Edit", match: :first

    click_on "Update Review card"

    assert_text "Review card was successfully updated"
    click_on "Back"
  end

  test "destroying a Review card" do
    visit review_cards_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Review card was successfully destroyed"
  end
end
