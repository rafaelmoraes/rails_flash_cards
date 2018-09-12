# frozen_string_literal: true

require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deck = decks(:always_valid)
  end

  test "should start review" do
    get start_deck_review_url(@deck)
    assert_redirected_to deck_review_card_url(@deck,
                                              @deck.current_card_id_on_review)
  end

  test "should get review settings" do
    get settings_deck_review_url(@deck)
    assert_response :success
  end

  test "should update review settings" do
    patch update_settings_deck_review_url(@deck), params: { deck: {
      name: @deck.name,
      detail: @deck.detail,
      cards_per_review: @deck.cards_per_review,
      repeat_easy_card: @deck.repeat_easy_card,
      repeat_medium_card: @deck.repeat_medium_card,
      repeat_hard_card: @deck.repeat_hard_card
    } }
    assert_redirected_to settings_deck_review_url(@deck)
  end
end
