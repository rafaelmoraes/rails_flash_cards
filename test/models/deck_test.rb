# frozen_string_literal: true

require 'test_helper'

# This class implements the unit tests to model Deck
class DeckTest < ActiveSupport::TestCase
  test 'should create a new deck' do
    new_deck = Deck.create user: users(:always_valid),
                           name: 'My First Deck',
                           detail: 'Deck to study everything'
    refute new_deck.new_record?
  end

  test 'should not create without an user' do
    new_deck = Deck.new name: 'My Second Deck',
                        detail: 'This deck never will be saved'
    refute new_deck.save
  end

  test 'should not create if user already have a deck with the same name' do
    deck = Deck.new user: decks(:always_valid).user,
                    name: decks(:always_valid).name
    refute deck.save
  end

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

  test 'should be configured counter_cache' do
    deck = decks :always_valid
    old_count = deck.cards_count
    deck.cards.create front: 'Test', back: 'Teste'
    assert old_count < deck.cards_count
  end

  test 'should destroy the deck and your cards' do
    deck = Deck.second
    card_ids = deck.card_ids
    deck.destroy
    refute_empty card_ids
    assert_nil Card.find_by(id: card_ids)
  end

  private

  def clone_deck(fixture_key = :spanish)
    decks(fixture_key).clone
  end
end
