# frozen_string_literal: true

class ReviewCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review_card, only: %i[show fail hit]

  def show
  end

  def hit
    respond_to do |format|
      if @card.hit_and_save
        next_card_id = @card.next_card_id_for_review
        format.html do
          redirect_to deck_review_card_path(@card.deck_id, next_card_id), notice: "Acertou"
        end
        format.json do
          render :show, status: :ok, location: [@card.deck_id, @card]
        end
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def fail
  end

  private
    def set_review_card
      card_id = params[:id] || params[:card_id]
      @card = Card.where(id: card_id,
        deck_id: params[:deck_id], user: current_user).first
    end
end
