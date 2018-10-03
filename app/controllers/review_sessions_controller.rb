# frozen_string_literal: true

class ReviewSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def answer
    respond_to do |format|
      if @review.save_answer(review_params[:answer])
        format.html do
          if @review.session_completed?
            redirect_to review_done_path(@review)
          else
            redirect_to review_card_path(@review, @review.current_card_id)
          end
        end
        format.json do
          if @review.session_completed?
            render :done, status: :ok, location: @review
          else
            render :show, status: :ok, location: [@review,
                                                  @review.current_card_id]
          end
        end
      else
        format.html { render :show }
        format.json do
          render json: @review.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def change_difficulty
    respond_to do |format|
      if @review.change_difficulty!(review_params[:change_to])
        format.html do
          redirect_to review_card_path(@review, @review.current_card_id)
        end
        format.json do
          render :show, status: :ok, location: [@review, @review.current_card]
        end
      else
        format.html { render :show }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_review
      @review = Review.where(id: review_params[:review_id],
                             user: current_user).first
    end

    def review_params
      params.permit :utf8,
                    :locale,
                    :answer,
                    :card_id,
                    :_method,
                    :review_id,
                    :change_to,
                    :authenticity_token
    end
end
