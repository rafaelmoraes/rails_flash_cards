# frozen_string_literal: true

require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:always_valid)
  end

  test "should redirect to sign in if user not logged" do
    sign_out @current_user
    get edit_review_url(@review)
    assert_redirected_to new_user_session_url
  end

  test "should start review" do
    deck_id = @review.deck_id
    review_id = @review.id
    card_id = @review.current_card_id
    get start_deck_review_url(deck_id)
    assert_redirected_to review_card_url(review_id, card_id)
  end

  test "should get review edit" do
    get edit_review_url(@review)
    assert_response :success
  end

  test "should update review settings" do
    patch review_url(@review), params: { review: {
                                  cards_per_day: @review.cards_per_day,
                                  repeat_easy: @review.repeat_easy,
                                  repeat_medium: @review.repeat_medium,
                                  repeat_hard: @review.repeat_hard
                                } }
    assert_redirected_to edit_review_url(@review)
  end
end
