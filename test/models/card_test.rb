# frozen_string_literal: true

require 'test_helper'

# Unit tests to model Card
class CardTest < ActiveSupport::TestCase
  test 'should save' do
    card = Card.new(front: 'Test', back: 'Teste', deck: decks(:always_valid))
    assert card.save
  end

  test 'should not save without front' do
    card = Card.new(back: 'Resposta', deck: decks(:always_valid))
    refute card.save
  end

  test 'should not save without back' do
    card = Card.new(front: 'Some word', deck: decks(:always_valid))
    refute card.save
  end

  test 'should not save if front or back is longer than 150 characters' do
    card = clone_card :four
    card.front = card.back = 'E' * 151
    refute card.save
  end

  test 'should not save if difficulty_level not is "easy", "medium" or "hard"' do
    card = clone_card :three
    card.difficulty_level = nil
    refute card.save
    card.difficulty_level = ''
    refute card.save
    assert_raises(ArgumentError) do
      card.difficulty_level = 'hell'
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
    refute card.save
    card.learned = ''
    refute card.save
  end

  test 'should not save if views_count not is 0 or greater' do
    card = clone_card :two
    card.views_count = 1.1
    refute card.save
    card.views_count = -1
    refute card.save
  end

  test 'should respond to deck method' do
    card = Card.new
    assert_respond_to card, :deck
  end

  test 'should return the user' do
    refute_nil Card.last.user
  end

  private

  def clone_card(fixture_key = :always_valid)
    cards(fixture_key).clone
  end
end
