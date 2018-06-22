# frozen_string_literal: true

require 'test_helper'

# This class implements the unit tests to model Deck
class DeckTest < ActiveSupport::TestCase
  test 'should save' do
    valid_deck = decks :always_valid
    assert valid_deck.save
  end

  test 'should not save' do
    deck = Deck.new
    refute deck.save
  end

  test 'should has an error about presence of the name' do
    deck = Deck.new
    deck.valid?
    refute_empty deck.errors[:name]
  end

  test 'should has an error about name is too long' do
    name_longer_than_max = 'A' * 76
    deck = clone_deck
    deck.name = name_longer_than_max
    deck.valid?
    refute_empty deck.errors[:name]
  end

  test 'should has an error about details is too long' do
    detail_longer_than_max = 'D' * 256
    deck = clone_deck
    deck.detail = detail_longer_than_max
    deck.valid?
    refute_empty deck.errors[:detail]
  end

  test 'should save without detail' do
    deck = clone_deck
    deck.detail = nil
    assert deck.save
  end

  test 'should has an error about cards_count needs be a number' do
    deck = clone_deck
    deck.cards_count = nil
    refute deck.valid?
    refute_empty deck.errors[:cards_count]
  end

  test 'should has an error about cards_count less than 0' do
    deck = clone_deck
    deck.cards_count = -12
    refute deck.valid?
    refute_empty deck.errors[:cards_count]
  end

  test 'should has an error about cards_count is not an integer' do
    deck = clone_deck
    deck.cards_count = 1.1
    refute deck.valid?
    refute_empty deck.errors[:cards_count]
  end

  test 'should respond to method user' do
    assert_respond_to Deck.new, :user
  end

  private

  def clone_deck(fixture_key = :spanish)
    decks(fixture_key).clone
  end
end
