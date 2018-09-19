# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def start
    redirect_to review_card_path(@review, @review.current_card_id)
  end

  def reset
  end

  def edit; end

  def update
    respond_to do |format|
      if @review.update(review_settings_params)
        format.html do
          redirect_to edit_review_path(@review), notice: t(".updated")
        end
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_review
      @review = Review.first_or_create(deck_id: review_params[:deck_id],
                                       user: current_user)
    end

    def review_params
      params.permit(:deck_id, :locale, :utf8, :_method,
        :authenticity_token, :review, :commit, :id)
    end

    def review_settings_params
      params.require(:review).permit(:cards_per_day,
                                     :repeat_easy,
                                     :repeat_medium,
                                     :repeat_hard)
    end
end
