# frozen_string_literal: true

require "application_system_test_case"

class CardsTest < ApplicationSystemTestCase
  setup do
    @deck = decks(:always_valid)
    @card = cards(:always_valid)
  end

  test "search cards of a Deck" do
    visit deck_cards_url(@deck)

    all("div.radio-buttons label").sample.click
    click_on t("index.search")

    assert_selector "h3", text: t("index.found_cards",
                                  number: @deck.cards_count + 1)
  end

  test "found a card using back content" do
    visit deck_cards_url(@deck)

    all("div.radio-buttons label").first.click
    find("label", text: t("index.back")).click
    find("#text").set(@deck.cards.first.back)
    click_on t("index.search")

    assert_selector "h3", text: t("index.found_cards", number: 1)
  end

  test "found a card using front content" do
    visit deck_cards_url(@deck)

    all("div.radio-buttons label").first.click
    find("label", text: t("index.front")).click
    find("#text").set(@deck.cards.last.front)
    click_on t("index.search")

    assert_selector "h3", text: t("index.found_cards", number: 1)
  end

  test "found a card using front or back content" do
    visit deck_cards_url(@deck)

    all("div.radio-buttons label").first.click
    find("label", text: t("index.both")).click
    find("#text").set(@deck.cards.first.front)
    click_on t("index.search")

    assert_selector "h3", text: t("index.found_cards", number: 1)
  end

  test "creating a Card" do
    visit new_deck_card_url(@deck)

    t_fill_in :front, with: "New Card"
    t_fill_in :back, with: "Nova Carta"
    all(".choose-difficulty label").sample.click
    t_click_submit :create

    t_assert_text "create.created"
  end

  test "should display save Card error messages" do
    visit new_deck_card_url(@deck)

    t_fill_in :front, with: ""
    t_fill_in :back, with: "Nova Carta " * 150
    t_click_submit :create

    assert_selector "#error_explanation"
  end

  test "go to edit from show Card" do
    visit deck_card_url(@card.deck, @card)
    click_on t(:edit)
    assert_selector "h1", text: t("edit.title")
  end

  test "updating a Card" do
    visit edit_deck_card_url(@card.deck, @card)

    t_fill_in :back, with: "#{@card.back} EDITED"
    t_fill_in :front, with: "#{@card.front} EDITED"
    find("div.checkbox label").click
    all(".choose-difficulty label").sample.click
    t_click_submit :update

    t_assert_text "update.updated"
  end

  test "destroying a Card" do
    visit deck_card_url(@card.deck, @card)
    page.accept_confirm do
      click_on t(:destroy)
    end
    t_assert_text "destroy.destroyed"
  end
end
