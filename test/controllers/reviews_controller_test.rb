# frozen_string_literal: true

require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:always_valid)
  end

  test "should start review" do
    # Necessary because fixtures don't run model callbacks
    @review.send :refresh_queue
    @review.save

    get start_deck_review_url(@review.deck_id)
    assert_redirected_to review_card_url(@review, @review.current_card_id)
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
    assert_response :success
  end
end
