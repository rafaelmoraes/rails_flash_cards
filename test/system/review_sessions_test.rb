# frozen_string_literal: true

require "application_system_test_case"

class ReviewSessionsTest < ApplicationSystemTestCase
  setup do
    @deck = decks(:always_valid)
  end

  test "should redirect to sign in page" do
    sign_out @current_user
    visit start_deck_review_url(@deck)
    t_assert_text :"devise.failure.unauthenticated"
  end

  test "presence of the review session functions" do
    visit start_deck_review_url(@deck)

    assert_selector "h1", text: @deck.name
    assert_selector "a", text: t("show.learned")
    assert_selector "button", text: t("show.level.easy")
    assert_selector "button", text: t("show.level.medium")
    assert_selector "button", text: t("show.level.hard")
    assert_selector "button", text: t("show.answer")
    assert_selector "button", text: t("show.wrong")
    assert_selector "button", text: t("show.right")
    assert_selector "div", text: @deck.review.current_card.front
    assert_selector "div", text: @deck.review.current_card.back, visible: false
  end

  test "should mark card as learned and remove it from session" do
    visit start_deck_review_url(@deck)
    learned_card_front = @deck.review.current_card.front
    assert_text learned_card_front
    click_on t("show.learned")
    assert_no_text learned_card_front
    assert_text @deck.review.current_card.front
  end

  test "should change card difficulty" do
    visit start_deck_review_url(@deck)
    card = @deck.review.current_card
    levels = %i[easy medium hard]
    levels = levels.reverse if card.easy?
    levels.each do |level|
      click_on t("show.level.#{level}")
      assert_selector "button:disabled", text: t("show.level.#{level}")
    end
  end

  test "should show the answer" do
    visit start_deck_review_url(@deck)
    assert_selector "div", text: @deck.review.current_card.front, visible: true
    assert_selector "div", text: @deck.review.current_card.back, visible: false
    find_button(t("show.answer")).hover
    assert_selector "div", text: @deck.review.current_card.front, visible: false
    assert_selector "div", text: @deck.review.current_card.back, visible: true
  end

  test "should answer wrong and go to the next card" do
    visit start_deck_review_url(@deck)
    old_session_cards_count = find(".review-status").text
    find_button(t("show.answer")).hover
    click_on t("show.wrong")
    current_session_cards_count = find(".review-status").text
    assert_not_equal current_session_cards_count, old_session_cards_count
  end

  test "should answer right and go to the next card" do
    visit start_deck_review_url(@deck)
    old_session_cards_count = find(".review-status").text
    find_button(t("show.answer")).hover
    click_on t("show.right")
    current_session_cards_count = find(".review-status").text
    assert_not_equal current_session_cards_count, old_session_cards_count
  end

  test "should redirect to review done page" do
    visit start_deck_review_url(@deck)
    @deck.review.total_queue_size.times do
      find_button(t("show.answer")).hover
      click_on t("show.right")
    end
    assert_selector "h1", text: @deck.name
    assert_selector "div.info"
  end
end
