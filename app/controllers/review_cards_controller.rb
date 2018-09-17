# frozen_string_literal: true

class ReviewCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resources_for_show, only: :show
  before_action :set_resources, except: :show

  def show
  end

  def hit
    execute_and_respond_to :hit_and_save
  end

  def miss
    execute_and_respond_to :miss_and_save
  end

  private
    def execute_and_respond_to(method_name)
      Review.transaction do
        respond_to do |format|
            if @card.send(method_name)
              format.html do
                redirect_to review_card_path(@review, @review.next_card_id)
              end
              format.json do
                render :show, status: :ok, location: [@review, @card]
              end
            else
              format.html { render :show }
              format.json do
                render json: @card.errors, status: :unprocessable_entity
              end
            end
          end
      end
    end

    def card_params
      params.permit(:id, :card_id, :review_id, :locale)
    end

    def set_resources_for_show
      @card = find_card(card_params[:id])
      @review_id = card_params[:review_id]
    end

    def set_resources
      @card = find_card(card_params[:card_id])
      @review = Review.where(id: card_params[:review_id],
                             user: current_user).first
    end

    def find_card(id)
      Card.where(id: id, user: current_user).first
    end
end
