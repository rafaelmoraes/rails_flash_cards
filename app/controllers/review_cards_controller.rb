class ReviewCardsController < ApplicationController
  before_action :set_review_card, only: [:show, :edit, :update, :destroy]

  # GET /review_cards
  # GET /review_cards.json
  def index
    @review_cards = ReviewCard.all
  end

  # GET /review_cards/1
  # GET /review_cards/1.json
  def show
  end

  # GET /review_cards/new
  def new
    @review_card = ReviewCard.new
  end

  # GET /review_cards/1/edit
  def edit
  end

  # POST /review_cards
  # POST /review_cards.json
  def create
    @review_card = ReviewCard.new(review_card_params)

    respond_to do |format|
      if @review_card.save
        format.html { redirect_to @review_card, notice: 'Review card was successfully created.' }
        format.json { render :show, status: :created, location: @review_card }
      else
        format.html { render :new }
        format.json { render json: @review_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_cards/1
  # PATCH/PUT /review_cards/1.json
  def update
    respond_to do |format|
      if @review_card.update(review_card_params)
        format.html { redirect_to @review_card, notice: 'Review card was successfully updated.' }
        format.json { render :show, status: :ok, location: @review_card }
      else
        format.html { render :edit }
        format.json { render json: @review_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_cards/1
  # DELETE /review_cards/1.json
  def destroy
    @review_card.destroy
    respond_to do |format|
      format.html { redirect_to review_cards_url, notice: 'Review card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review_card
      @review_card = ReviewCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_card_params
      params.fetch(:review_card, {})
    end
end
