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

  private

    def clone_card(fixture_key = :always_valid)
      cards(fixture_key).clone
    end
end
