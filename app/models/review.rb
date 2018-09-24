# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  validates_numericality_of :cards_per_day,
                            :repeat_easy,
                            :repeat_medium,
                            :repeat_hard,
                            only_integer: true,
                            greater_than: 0

  def hit_and_forward!
    Review.transaction do
      current_card.hit!
      forward!
    end
  end

  def miss_and_forward!
    Review.transaction do
      current_card.miss!
      forward!
    end
  end

  def current_card_id
    create_daily_session! if first_deck_review_session_of_day?
    card_id = self.queue.first
    Card.exists?(card_id) ? card_id : replace_current_card!
  end

  def current_card
    return @card if @card && @card.id == current_card_id
    @card = Card.find(current_card_id)
  end

  def first_deck_review_session_of_day?
    !daily_review_done || session_date != Time.now.to_date
  end

  private
    def forward!
      self.queue.delete_at 0
      finish_daily_session if self.queue.empty?
      save
    end

    def create_daily_session!
      build_queue
      today = Time.now.to_date
      offensive = 0 if (today - session_date).to_i > 1
      session_date = today
      daily_review_done = false
      save
    end

    def create_extra_session!
      build_queue
      save
    end

    def finish_daily_session
      if daily_review_done == false
        self.offensive += 1
        self.daily_review_done = true
      end
      self.reviews_completed += 1
    end

    def build_queue
      self.queue = [] if self.queue.any?
      cards.limit(cards_per_day).each { |card| add_to_queue(card) }
      shuffle_queue
    end

    def add_to_queue(card)
      times = send("repeat_#{card.level}")
      self.queue += Array.new(times, card.id)
    end

    def replace_current_card!
      return if self.queue.empty?
      queue.delete(queue.first)
      substitute = cards.limit(1).where.not(id: queue.uniq).first
      add_to_queue substitute
      shuffle_queue
      queue.first if save
    end

    def shuffle_queue
      queue.shuffle! unless Rails.env.test?
    end

    def cards
      deck.cards.where(learned: false)
                .select(:id, :level)
                .order(review_count: :asc, miss_count: :desc)
    end
end
