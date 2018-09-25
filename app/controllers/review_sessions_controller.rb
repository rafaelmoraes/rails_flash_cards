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
            if @review.daily_review_done?
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
      params.permit(:review_id)
    end
end
