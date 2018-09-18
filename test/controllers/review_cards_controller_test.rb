# frozen_string_literal: true

require "test_helper"

class ReviewCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:always_valid)
    @review.send :build_session
    @review.save
  end

  test "should show review_card" do
    get review_card_url(@review, @review.current_card_id)
    assert_response :success
  end

  test "should get hit" do
    get review_card_hit_url(@review, @review.current_card_id)
    assert_redirected_to review_card_url(@review, @review.next_card_id)
  end

  test "should get miss" do
    get review_card_miss_url(@review, @review.current_card_id)
    assert_redirected_to review_card_url(@review, @review.next_card_id)
  end
end
