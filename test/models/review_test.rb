# frozen_string_literal: true

require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "should not save when queue is not an Array" do
    r = clone_review
    r.queue = nil
    r.valid?
    assert_not_empty r.errors[:queue]
  end

  test "should not save" do
    r = Review.new
    assert_not r.save
  end

  test "should build the review queue" do
    review = clone_review
    assert_empty review.queue
    review.current_card_id
    assert_not_empty review.queue
  end

  test "should has error about not be a positive integer" do
    r = Review.new
    %i[reviewed_on_session cards_per_day
      repeat_easy repeat_medium repeat_hard].each do |m|
      [0, -1, 1.7, nil].each do |v|
        r.send("#{m}=", v)
        r.valid?
        assert_not_empty r.errors[m]
      end
    end
  end

  test "should has error about not be an integer equal zero or greater" do
    r = Review.new
    %i[offensive reviews_completed].each do |m|
      [1.8, -1, nil].each do |v|
        r.send("#{m}=", v)
        r.valid?
        assert_not_empty r.errors[m]
      end
    end
  end

  test "daily_review_done should be only boolean values" do
    r = Review.new
    ["", nil].each do |v|
      r.daily_review_done = v
      r.valid?
      assert_not_empty r.errors[:daily_review_done]
    end
  end

  test "should replace automatically a deleted card for another from deck" do
    r = clone_review
    r.current_card_id
    current_queue = r.queue
    r.queue[1] = 0
    r.miss_and_forward!
    assert_not_nil r.current_card_id
    assert_kind_of Card, r.current_card
    assert_not_equal 0, r.current_card_id
    assert_not_equal 0, r.current_card.id
    assert_not_includes r.queue, 0
  end

  test "should consider the review session completed" do
    review = clone_review
    review.current_card_id
    review.queue = [review.queue[0]]
    review.hit_and_forward!
    assert review.session_completed?
  end

  test "should reset the offensive counter" do
    review = clone_review
    review.offensive = 15
    review.session_date = (Time.now - 2.days).to_date
    review.queue = []
    assert_equal 15, review.offensive
    assert_empty review.queue
    review.miss_and_forward!
    assert_equal 0, review.offensive
  end

  test "should increase offensive and reviews_completed counter when daily review is done" do
    review = clone_review
    offensive = review.offensive
    completed = review.reviews_completed
    while !review.daily_review_done? do
      review.hit_and_forward!
    end
    assert_equal (offensive + 1), review.offensive
    assert_equal (completed + 1), review.reviews_completed
  end

  test "should increase only reviews_completed when another session is done at same day" do
    review = clone_review
    offensive = review.offensive
    completed = review.reviews_completed
    while !review.daily_review_done? do
      review.hit_and_forward!
    end
    review.current_card_id
    while !review.session_completed? do
      review.miss_and_forward!
    end
    assert_equal (offensive + 1), review.offensive
    assert_equal (completed + 2), review.reviews_completed
  end

  test "should mark a hit for current_card and delete it from queue" do
    review = clone_review
    card = review.current_card
    old_hit_count = card.hit_count
    old_queue_size = review.queue.size
    review.hit_and_forward!
    assert_equal (old_queue_size - 1), review.queue.size
    assert_equal (old_hit_count + 1), card.hit_count
  end

  test "should mark a miss for current_card and delete it from queue" do
    review = clone_review
    card = review.current_card
    old_miss_count = card.miss_count
    old_queue_size = review.queue.size
    review.miss_and_forward!
    assert_equal (old_queue_size - 1), review.queue.size
    assert_equal (old_miss_count + 1), card.miss_count
  end

  test "should daily_review_done become true" do
    review = clone_review
    assert_not review.daily_review_done?
    while !review.session_completed? do
      review.hit_and_forward!
    end
    assert review.daily_review_done?
  end

  private
    def clone_review(fixture_key = :always_valid)
      reviews(fixture_key).clone
    end
end
