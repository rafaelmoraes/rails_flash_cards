# frozen_string_literal: true

require "test_helper"

# CardsController Integration Tests
class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deck = decks :always_valid
    @card = cards :one
  end

  test "should redirect to sign in if user not logged" do
    sign_out @current_user
    get deck_cards_url(@deck)
    assert_redirected_to new_user_session_url
  end

  test "should get index" do
    get deck_cards_url(@deck)
    assert_response :success
  end

  test "should get new" do
    get new_deck_card_url(@deck)
    assert_response :success
  end

  test "should create card" do
    assert_difference("Card.count") do
      post deck_cards_url(@card.deck), params: {
        card: { back: @card.back,
                difficulty_level: @card.difficulty_level,
                front: @card.front,
                learned: @card.learned,
                review_count: @card.review_count },
        deck_id: @card.deck_id
      }
    end

    assert_redirected_to deck_url(Card.last.deck_id)
  end

  test "should show card" do
    get deck_card_url(@card.deck, @card)
    assert_response :success
  end

  test "should get edit" do
    get edit_deck_card_url(@card.deck, @card)
    assert_response :success
  end

  test "should update card" do
    patch deck_card_url(@card.deck, @card),
          params: {
            card: {
              back: @card.back,
              difficulty_level: @card.difficulty_level,
              front: @card.front,
              learned: @card.learned,
              review_count: @card.review_count
            },
            deck_id: @card.deck_id
          }
    assert_redirected_to deck_card_url(@card.deck, @card)
  end

  test "should destroy card" do
    deck = @card.deck
    assert_difference("Card.count", -1) do
      delete deck_card_url(@card.deck, @card)
    end

    assert_redirected_to deck_url(deck)
  end
end
