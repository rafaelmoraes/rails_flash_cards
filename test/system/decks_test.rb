# frozen_string_literal: true

require "application_system_test_case"

class DecksTest < ApplicationSystemTestCase
  setup do
    @deck = decks(:always_valid)
    @locale ||= I18n.available_locales.sample
  end

  test "visiting the index" do
    visit locale_url :decks_url
    assert_selector "h1", text: t("index.title")
  end

  test "go to new Deck" do
    visit locale_url :decks_url
    click_on t("index.new")
    assert_selector "h1", text: t("new.title")
  end

  test "creating a Deck" do
    visit locale_url :new_deck_url

    assert_selector "h1", text: t("new.title")

    t_fill_in :detail, with: "Super Deck to learn super things"
    t_fill_in :name, with: "Super Deck"
    t_click_on :create

    t_assert_text "create.created"
  end

  test "got to show a Deck" do
    visit locale_url :decks_url
    click_on @deck.name
    assert_text @deck.detail
  end

  test "updating a Deck" do
    visit locale_url :deck_url, @deck
    click_on t(:edit), match: :first

    t_fill_in :detail, with: "#{@deck.detail} EDITED"
    t_fill_in :name, with: "#{@deck.name} EDITED"
    t_click_on :update

    t_assert_text "update.updated"
  end
  #
  # test "destroying a Deck" do
  #   visit l_decks_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end
  #
  #   assert_text "Deck was successfully destroyed"
  # end

  private
    def locale_url(method, *params)
      send(method, *params, locale: @locale)
    end

    def t(key)
      return I18n.t(key) if key.is_a? Symbol
      I18n.t("decks.#{key}")
    end

    def t_fill_in(attr_name, *params)
      fill_in I18n.t("activerecord.attributes.deck.#{attr_name}"), *params
    end

    def t_click_on(key)
      click_on I18n.t("helpers.submit.#{key}",
                      model: I18n.t("activerecord.models.deck"))
    end

    def t_assert_text(key)
      assert_text t(key)
    end
end
