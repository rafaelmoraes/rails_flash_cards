# frozen_string_literal: true

require "test_helper"

# Unit tests to model Card
class CardTest < ActiveSupport::TestCase
  test "should save" do
    card = Card.new front: "Test",
                    back: "Teste",
                    deck: decks(:always_valid),
                    user: users(:always_valid)
    assert card.save
  end

  test "should not save without front" do
    card = Card.new(back: "Resposta", deck: decks(:always_valid))
    assert_not card.save
  end

  test "should not save without back" do
    card = Card.new(front: "Some word", deck: decks(:always_valid))
    assert_not card.save
  end

  test "should not save if front or back is longer than 150 characters" do
    card = clone_card :four
    card.front = card.back = "E" * 151
    assert_not card.save
  end

  test 'should not save if difficulty_level not is "easy", "medium" or "hard"' do
    card = clone_card :three
    card.difficulty_level = nil
    assert_not card.save
    card.difficulty_level = ""
    assert_not card.save
    assert_raises(ArgumentError) do
      card.difficulty_level = "hell"
    end
  end

  test 'should responde to enums "easy", "medium" and "hard"' do
    card = cards(:always_valid)
    assert_respond_to card, :easy?
    assert_respond_to card, :medium?
    assert_respond_to card, :hard?
  end

  test 'should not save if learned not is "true" or "false"' do
    card = clone_card :one
    card.learned = nil
    assert_not card.save
    card.learned = ""
    assert_not card.save
  end

  test "should not save if hit_count not is a positive integer or zero" do
    card = clone_card :three
    card.hit_count = 1.1
    assert_not card.save
    card.hit_count = -1
    assert_not card.save
  end

  test "should not save if miss_count not is a positive integer or zero" do
    card = clone_card :three
    card.miss_count = 1.1
    assert_not card.save
    card.miss_count = -1
    assert_not card.save
  end

  test "should not save if review_count not is a positive integer or zero" do
    card = clone_card :three
    card.review_count = 1.1
    assert_not card.save
    card.review_count = -1
    assert_not card.save
  end

  test "should respond to deck method" do
    card = Card.new
    assert_respond_to card, :deck
  end

  test "should return the user" do
    assert_not_nil Card.last.user
  end

  test "should not save if user is different to deck user" do
    card = clone_card :always_valid
    card.user = users :rafael
    assert_not card.save
  end

  test "should increase hit_count and review_count" do
    card = clone_card :always_valid
    old_hit_count = card.hit_count
    old_review_count = card.review_count
    card.hit!
    assert_equal (old_hit_count + 1), card.hit_count
    assert_equal (old_review_count + 1), card.review_count
  end

  test "should increase miss_count and review_count" do
    card = clone_card :always_valid
    old_miss_count = card.miss_count
    old_review_count = card.review_count
    card.miss!
    assert_equal (old_miss_count + 1), card.miss_count
    assert_equal (old_review_count + 1), card.review_count
  end

  test "should change the difficulty_level and save" do
    card = clone_card :always_valid
    assert_not card.hard?
    new_difficulty_level = Card::DIFFICULTY_LEVELS.values.sample
    assert card.change_difficulty!(new_difficulty_level)
    card.reload
    assert card.send("#{new_difficulty_level}?")
  end

  test "should set to learned and save" do
    card = clone_card :always_valid
    assert_not card.learned?
    assert card.learned!
    assert card.learned?
  end

  test "should find a card by front content" do
    c = Card.where_front("Perhaps").first
    assert_equal "Perhaps", c.front
  end

  test "should find a card by back content" do
    c = Card.where_back("Porta").first
    assert_equal "Porta", c.back
  end

  test "should find a card by front or back content" do
    c = Card.where_front_or_back("Door").first
    assert_equal "Door", c.front
  end

  private
    def clone_card(fixture_key = :always_valid)
      cards(fixture_key).clone
    end
end
