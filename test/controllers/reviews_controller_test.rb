# frozen_string_literal: true

require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:always_valid)
  end

  test "should start review" do
    get start_deck_review_url(@review)
    assert_redirected_to review_card_url(@review, @review.current_card_id)
  end

  test "should get review edit" do
    get edit_review_url(@review)
    assert_response :success
  end

  test "should update review settings" do
    patch review_url(@review), params: { review: {
                                  cards_per_review: @review.cards_per_day,
                                  repeat_easy_card: @review.repeat_easy,
                                  repeat_medium: @review.repeat_medium,
                                  repeat_hard: @review.repeat_hard
                                } }
    assert_redirected_to edit_review_url(@review)
  end
end
