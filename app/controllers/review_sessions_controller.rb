# frozen_string_literal: true

class ReviewSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def show
  end

  def hit
    execute_and_respond_to :hit_and_forward!
  end

  def miss
    execute_and_respond_to :miss_and_forward!
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
    def execute_and_respond_to(method_name)
      respond_to do |format|
        if @review.send(method_name)
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

    def set_review
      @review = Review.where(id: review_params[:review_id],
                             user: current_user).first
    end

    def review_params
      params.permit :utf8,
                    :locale,
                    :card_id,
                    :_method,
                    :review_id,
                    :change_to,
                    :authenticity_token
    end
end
