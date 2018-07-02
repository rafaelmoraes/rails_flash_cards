# frozen_string_literal: true

# Controller to Decks
class DecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deck, only: %i[show edit update destroy]

  def index
    @decks = Deck.where user: current_user
  end

  def show; end

  def new
    @deck = Deck.new
  end

  def edit; end

  def create
    @deck = Deck.new(deck_params)
    respond_to do |format|
      if @deck.save
        format.html do
          redirect_to @deck, notice: 'Deck was successfully created.'
        end
        format.json { render :show, status: :created, location: @deck }
      else
        format.html { render :new }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @deck.update(deck_params)
        format.html do
          redirect_to @deck, notice: 'Deck was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @deck }
      else
        format.html { render :edit }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @deck.destroy
    respond_to do |format|
      format.html do
        redirect_to decks_url,
                    notice: 'Deck was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def set_deck
    @deck = Deck.where(id: params[:id], user: current_user).first
  end

  def deck_params
    received_params = params.require(:deck).permit(:name, :detail, :id)
    received_params[:user] = current_user
    received_params
  end
end
