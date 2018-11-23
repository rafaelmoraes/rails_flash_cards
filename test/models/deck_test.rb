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

  test "should destroy the Italian deck and your cards and review" do
    deck = Deck.where(name: "Italian").includes(:user, :review).first
    card_ids = deck.card_ids
    review_id = deck.review.id
    deck.destroy
    assert_not_empty card_ids
    assert_not_nil review_id
    assert_nil Card.find_by(id: card_ids)
    assert_nil Review.find_by(id: review_id)
  end

  test "should return only 2 cards" do
    deck = Deck.first
    assert_equal 2, deck.cards_for_review(2).count
  end

  test "should return a card that is not between at cards informed" do
    deck = Deck.first
    exclude_card_ids = deck.card_ids.slice(0, 1)
    card = deck.find_substitute_card(exclude_card_ids)
    assert_not_includes exclude_card_ids, card.id
  end

  test "should has an error about invalid color" do
    deck = Deck.first
    assert deck.valid?
    deck.color = "#000"
    deck.valid?
    assert_not_empty deck.errors[:color]
  end

  test "color can't be nil" do
    deck = Deck.first
    assert deck.valid?
    deck.color = nil
    assert_not deck.valid?
  end

  test "reviewed at should be not nil" do
    deck = Deck.new
    deck.reviewed_at = nil
    deck.valid?
    assert_not_empty deck.errors[:reviewed_at]
  end

  test "daily_review_done should be false" do
    deck = decks :always_valid
    assert_not deck.daily_review_done?
  end

  test "daily_review_done should be true" do
    deck = decks :always_valid
    deck.reviewed_at = Date.today
    assert deck.daily_review_done?
  end

  test "daily_review_not_done should be true" do
    deck = decks :always_valid
    assert deck.daily_review_not_done?
  end

  test "should be true if deck has at least one card as not learned" do
    deck = decks :always_valid
    assert deck.has_cards_to_review?
    cards_from_this_deck = Card.where(deck_id: deck.id)
    cards_from_this_deck.update_all(learned: true)
    assert_not deck.has_cards_to_review?
    cards_from_this_deck.delete_all
    assert_not deck.has_cards_to_review?
  end

  test "should create review after create a new deck" do
    deck = Deck.create(user: users(:always_valid),
                       name: "Test before create callback")
    deck.send(:create_review!)
    assert_not_nil deck.review
    assert_not deck.review.new_record?
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
