# frozen_string_literal: true

class ReviewSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def learned
    choose_next_action @review.learned_and_forward!
  end

  def answer
    answer = review_params[:answer]
    choose_next_action @review.save_answer(answer)
  end

  def change_difficulty
    choose_next_action @review.change_difficulty!(review_params[:change_to])
  end

  private
    def choose_next_action(success)
      respond_to do |format|
        success ? success_response(format) : error_response(format)
      end
    end

    def success_response(format)
      if @review.session_completed?
        format.html { redirect_to review_done_path(@review) }
        format.json { render :done, status: :ok, location: @review }
      else
        path = review_card_path(@review, @review.current_card_id)
        format.html { redirect_to path }
        format.json { render :show, status: :ok, location: path }
      end
    end

    def error_response(format)
      format.html { render :show }
      format.json { render json: @review.errors, status: :unprocessable_entity }
    end

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
