# frozen_string_literal: true

require "test_helper"

# This class implements the unit tests to model Deck
class DeckTest < ActiveSupport::TestCase
  test "should create a new deck" do
    new_deck = Deck.create user: users(:always_valid),
                           name: "My First Deck",
                           detail: "Deck to study everything"
    assert_not new_deck.new_record?
  end

  test "should not create without an user" do
    new_deck = Deck.new name: "My Second Deck",
                        detail: "This deck never will be saved"
    assert_not new_deck.save
  end

  test "should not create if user already have a deck with the same name" do
    deck = Deck.new user: decks(:always_valid).user,
                    name: decks(:always_valid).name
    assert_not deck.save
  end

  test "should save" do
    valid_deck = decks :always_valid
    assert valid_deck.save
  end

  test "should not save" do
    deck = Deck.new
    assert_not deck.save
  end

  test "should has an error about presence of the name" do
    deck = Deck.new
    deck.valid?
    assert_not_empty deck.errors[:name]
  end

  test "should has an error about name is too long" do
    name_longer_than_max = "A" * 76
    deck = clone_deck
    deck.name = name_longer_than_max
    deck.valid?
    assert_not_empty deck.errors[:name]
  end

  test "should has an error about details is too long" do
    detail_longer_than_max = "D" * 256
    deck = clone_deck
    deck.detail = detail_longer_than_max
    deck.valid?
    assert_not_empty deck.errors[:detail]
  end

  test "should save without detail" do
    deck = clone_deck
    deck.detail = nil
    assert deck.save
  end

  test "should has an error about cards_count needs be a number" do
    deck = clone_deck
    deck.cards_count = nil
    assert_not deck.valid?
    assert_not_empty deck.errors[:cards_count]
  end

  test "should has an error about cards_count less than 0" do
    deck = clone_deck
    deck.cards_count = -12
    assert_not deck.valid?
    assert_not_empty deck.errors[:cards_count]
  end

  test "should has an error about cards_count is not an integer" do
    deck = clone_deck
    deck.cards_count = 1.1
    assert_not deck.valid?
    assert_not_empty deck.errors[:cards_count]
  end

  test "should respond to method user" do
    assert_respond_to Deck.new, :user
  end

  test "should be configured counter_cache" do
    deck = decks :always_valid
    assert_difference("deck.cards_count", 1) do
      deck.cards.create front: "Test", back: "Teste", user: users(:always_valid)
    end
  end

  test "should destroy the deck and your cards" do
    deck = Deck.second
    card_ids = deck.card_ids
    deck.destroy
    assert_not_empty card_ids
    assert_nil Card.find_by(id: card_ids)
  end

  test "should be a integer greater than 0" do
    deck = clone_deck :always_valid
    %i[cards_per_review repeat_easy_card repeat_hard_card
      repeat_medium_card card_id_on_review].each do |attr_name|
      assert deck.valid?
      default_value = deck.send attr_name
      [-1, 1.1, 0].each do |number|
        deck.send "#{attr_name}=", number
        assert_not deck.valid?
        assert_includes deck.errors, attr_name
      end
      deck.send "#{attr_name}=", default_value
    end
  end

  test "should return the current card id on review" do
    deck = decks :always_valid
    assert_kind_of Numeric, deck.current_card_id_on_review
  end

  private

    def create_deck
      user = User.create first_name: "José",
                         last_name: "Silva",
                         email: "js@email.com",
                         password: "123456",
                         password_confirmation: "123456"
      Deck.create name: "Teste create review", user: user
    end

    def clone_deck(fixture_key = :spanish)
      decks(fixture_key).clone
    end
end
