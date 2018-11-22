# frozen_string_literal: true

require "application_system_test_case"

class DecksTest < ApplicationSystemTestCase
  setup do
    @deck = decks(:always_valid)
  end

  test "should redirect to sign in page" do
    sign_out @current_user
    visit decks_url
    t_assert_text :"devise.failure.unauthenticated"
  end

  test "visiting the index" do
    visit decks_url
    assert_selector "h1", text: t("index.title")
  end

  test "go to new Deck from index" do
    visit decks_url
    click_on t("index.new")
    assert_selector "h1", text: t("new.title")
  end

  test "start review from index decks list" do
    visit decks_url
    click_on t("index.start_review"), match: :first
    assert_selector "h1", text: @deck.name
  end

  test "go to new card from index decks list" do
    visit decks_url
    click_on t("index.new_card"), match: :first
    assert_selector "h1", text: @deck.name
    assert_selector "h2", text: t(:"cards.new.title")
  end

  test "creating a Deck" do
    visit new_deck_url

    assert_selector "h1", text: t("new.title")

    t_fill_in :detail, with: "Super Deck to learn super things"
    t_fill_in :name, with: "Super Deck"
    t_click_submit :create

    t_assert_text "create.created"
  end

  test "got to show a Deck" do
    visit decks_url
    click_on @deck.name
    assert_text @deck.detail
  end

  test "updating a Deck" do
    visit deck_url(@deck)
    click_on t(:edit)

    t_fill_in :detail, with: "#{@deck.detail} EDITED"
    t_fill_in :name, with: "#{@deck.name} EDITED"
    all("div.choose-color label").sample.click
    t_click_submit :update

    t_assert_text "update.updated"
  end

  test "should display the update Deck error messages" do
    visit deck_url(@deck)
    click_on t(:edit)

    t_fill_in :detail, with: "#{@deck.detail * 50 }"
    t_fill_in :name, with: ""
    t_click_submit :update

    assert_selector "#error_explanation"
  end

  test "destroying a Deck" do
    visit deck_url(@deck)
    page.accept_confirm do
      click_on t(:destroy)
    end

    t_assert_text "destroy.destroyed"
  end

  test "go to add new card" do
    visit deck_url(@deck)
    click_on t("show.new_card")
    assert_selector "h1", text: @deck.name
    assert_selector "h2", text: t(:"cards.new.title")
  end

  test "go to edit Deck" do
    visit deck_url(@deck)
    click_on t(:edit)
    assert_selector "h1", text: t("edit.title")
  end

  test "go to search cards" do
    visit deck_url(@deck)
    click_on t("show.search_cards")
    assert_selector "h1", text: @deck.name
    assert_selector "button", text: t(:"cards.index.search")
  end

  test "go to review" do
    visit deck_url(@deck)
    click_on t("show.start_review")
    assert_selector "h1", text: @deck.name
    assert_selector "button", text: t(:"review_sessions.show.answer")
  end

  test "should hidden review session start button" do
    visit deck_url(decks(:no_cards))
    assert_no_selector "button", text: t("show.start_review")
  end
end
