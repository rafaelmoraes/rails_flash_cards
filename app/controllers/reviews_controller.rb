# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deck, only: [:settings, :update_settings]

  def start
  end

  def reset
  end

  def settings
  end

  def update_settings
    respond_to do |format|
      if @deck.update(settings_params)
        format.html do
          redirect_to settings_deck_review_path(@deck),
          notice: t(".updated")
        end
        format.json { render :show, status: :ok, location: @deck }
      else
        format.html { render :settings }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_deck
      @deck = Deck.where(id: review_params[:deck_id], user: current_user).first
    end

    def review_params
      params.permit(:deck, :deck_id, :utf8, :_method, :authenticity_token,
        :commit, :locale)
    end

    def settings_params
      params.require(:deck).permit(
        :cards_per_review,
        :repeat_easy_card,
        :repeat_medium_card,
        :repeat_hard_card)
    end
end
