# frozen_string_literal: true

# CardsController
class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card, only: %i[show edit update destroy]
  before_action :set_deck

  def index
    @cards = @deck.cards
  end

  def show; end

  def new
    @card = Card.new(deck: @deck)
  end

  def edit; end

  def create
    @card = current_user.cards.new card_params
    @card.deck = @deck
    respond_to do |format|
      if @card.save
        format.html { redirect_to [@card.deck, @card], notice: t('.created') }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to [@deck, @card], notice: t('.updated') }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to @deck, notice: t('.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def set_deck
    @deck = current_user.decks.find(params[:deck_id])
  end

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card)
          .permit(:front, :back, :difficulty_level, :learned, :deck_id)
  end
end
