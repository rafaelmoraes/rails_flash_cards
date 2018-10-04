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
    %i[cards_per_day
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

  test "should has error about not be an integer equal one or greater" do
    r = Review.new
    %i[queue_position].each do |m|
      [0, 1.8, -1, nil].each do |v|
        r.send("#{m}=", v)
        r.valid?
        assert_not_empty r.errors[m]
      end
    end
  end

  test "should replace automatically a deleted card for another from deck" do
    r = clone_review
    id_deleted = r.current_card_id
    Card.delete(id_deleted)
    assert_not_nil r.current_card_id
    assert_kind_of Card, r.current_card
    assert_not_equal id_deleted, r.current_card_id
    assert_not_equal id_deleted, r.current_card.id
    assert_not_includes r.queue, id_deleted
  end

  test "should consider the review session completed" do
    review = clone_review
    review.current_card_id
    review.queue = [review.queue[0]]
    review.save_answer(Review::RIGHT_ANSWER)
    assert review.session_completed?
  end

  test "should reset the offensive counter" do
    review = clone_review
    review.offensive = 15
    review.session_date = (Time.now - 2.days).to_date
    review.queue = []
    assert_equal 15, review.offensive
    assert_empty review.queue
    review.save_answer(Review::WRONG_ANSWER)
    assert_equal 0, review.offensive
  end

  test "should increase offensive and reviews_completed counter when daily review is done" do
    review = clone_review
    offensive = review.offensive
    completed = review.reviews_completed
    while !review.daily_review_done? do
      review.save_answer(Review::WRONG_ANSWER)
    end
    assert_equal (offensive + 1), review.offensive
    assert_equal (completed + 1), review.reviews_completed
  end

  test "should increase only reviews_completed when another session is done at same day" do
    review = clone_review
    offensive = review.offensive
    completed = review.reviews_completed
    while !review.daily_review_done? do
      review.save_answer(Review::RIGHT_ANSWER)
    end
    review.current_card_id
    while !review.session_completed? do
      review.save_answer(Review::WRONG_ANSWER)
    end
    assert_equal (offensive + 1), review.offensive
    assert_equal (completed + 2), review.reviews_completed
  end

  test "should mark a hit for current_card and delete it from queue" do
    review = clone_review
    card = review.current_card
    old_hit_count = card.hit_count
    old_queue_size = review.queue.size
    review.save_answer(Review::RIGHT_ANSWER)
    assert_equal (old_queue_size - 1), review.queue.size
    assert_equal (old_hit_count + 1), card.hit_count
  end

  test "should mark a miss for current_card and delete it from queue" do
    review = clone_review
    card = review.current_card
    old_miss_count = card.miss_count
    old_queue_size = review.queue.size
    review.save_answer(Review::WRONG_ANSWER)
    assert_equal (old_queue_size - 1), review.queue.size
    assert_equal (old_miss_count + 1), card.miss_count
  end

  test "should daily_review_done become true" do
    review = clone_review
    assert_not review.daily_review_done?
    while !review.session_completed? do
      review.save_answer(Review::RIGHT_ANSWER)
    end
    assert review.daily_review_done?
  end

  test "should changes current card difficulty level to 'easy' and update it from queue" do
    r = clone_review
    r.current_card_id
    r.queue.size.times do
      break if r.current_card.difficulty_level != "easy"
      r.send :forward!
    end
    assert_not_equal "easy", r.current_card.difficulty_level
    r.change_difficulty!("easy")
    assert_equal r.queue.count(r.current_card.id), r.repeat_easy
  end

  test "should changes current card difficulty level to 'medium' and update it from queue" do
    r = clone_review
    r.current_card_id
    r.queue.size.times do
      break if r.current_card.difficulty_level != "medium"
      r.send :forward!
    end
    assert_not_equal "medium", r.current_card.difficulty_level
    r.change_difficulty!("medium")
    assert_equal r.queue.count(r.current_card.id), r.repeat_medium
  end

  test "should changes current card difficulty level to 'hard' and update it from queue" do
    r = clone_review
    r.current_card_id
    r.queue.size.times do
      break if r.current_card.difficulty_level != "hard"
      r.send :forward!
    end
    assert_not_equal "hard", r.current_card.difficulty_level
    r.change_difficulty!("hard")
    assert_equal r.queue.count(r.current_card.id), r.repeat_hard
  end

  test "should set current card to learned" do
    r = clone_review
    learned_card = r.current_card
    assert r.learned_and_forward!
    learned_card.reload
    assert learned_card.learned?
    until r.session_completed?
      assert_not_equal learned_card.id, r.current_card_id
      r.send :forward!
    end
  end

  test "should replace current card to another if it was set as learned by card edit view" do
    r = clone_review
    assert_not r.current_card.learned?
    learned_card = Card.find_by(id: r.current_card.id)
    assert learned_card.learned!
    assert_not_equal r.current_card.id, learned_card.id
    assert_not r.current_card.learned?
  end

  private
    def clone_review(fixture_key = :always_valid)
      reviews(fixture_key).clone
    end
end
