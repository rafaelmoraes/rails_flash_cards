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

  validates_numericality_of :offensive,
                            :reviews_completed,
                            only_integer: true,
                            greater_than_or_equal_to: 0

  validates :daily_review_done, inclusion: { in: [true, false] }

  validate do
    errors.add(:queue, "needs be an Array") if queue.nil? || !queue.is_a?(Array)
  end

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
    create_session_if_necessary!
    card_id = self.queue.first
    Card.exists?(card_id) ? card_id : replace_current_card!
  end

  def current_card
    return @card if @card && @card.id == current_card_id
    @card = Card.find(current_card_id)
  end

  def session_completed?
    daily_review_done? && self.queue.empty?
  end

  private
    def forward!
      self.queue.delete_at 0
      finish_daily_session if self.queue.empty?
      save
    end

    def create_daily_session!
      build_queue
      self.offensive = 0 if restart_offensive?
      self.session_date = today_date
      self.daily_review_done = false
      save
    end

    def create_session_if_necessary!
      if self.queue.empty?
        extra_review_session? ? create_extra_session! : create_daily_session!
      end
    end

    def restart_offensive?
      session_date.nil? || (today_date - session_date).to_i > 1
    end

    def extra_review_session?
      session_date == today_date && daily_review_done?
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
      cards_for_review(cards_per_day).each { |card| add_to_queue(card) }
      shuffle_queue
    end

    def add_to_queue(card)
      times = send("repeat_#{card.level}")
      self.queue += Array.new(times, card.id)
    end

    def replace_current_card!
      self.queue.delete(queue.first)
      substitute = find_substitute
      add_to_queue substitute
      shuffle_queue
      queue.first if save
    end

    def find_substitute
      deck.find_substitute_card(queue.uniq)
    end

    def shuffle_queue
      queue.shuffle! unless Rails.env.test?
    end

    def cards_for_review(limit)
      deck.cards_for_review(limit)
    end

    def today_date
      @today_date ||= Time.now.to_date
    end
end
