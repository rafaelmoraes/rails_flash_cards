# frozen_string_literal: true

require "test_helper"

class ReviewSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:always_valid)
  end

  test "should show review_card" do
    get review_card_url(@review, @review.current_card_id)
    assert_response :success
  end

  test "should answer review" do
    patch_answer
    assert_redirected_to review_card_url(@review, @review.current_card_id)
  end

  test "should get done if be the last card of queue" do
    @review.current_card_id
    @review.queue = [@review.queue[0]]
    @review.save
    patch_answer
    assert_redirected_to review_done_url(@review)
  end

  private
    def patch_answer
      answer = %i[correct wrong].sample
      patch review_card_answer_url(@review, @review.current_card_id),
            params: { answer: answer }
    end
end
