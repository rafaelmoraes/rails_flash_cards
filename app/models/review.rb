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
    head_of_queue
  end

  def current_card
    return @card if @card && @card.id == head_of_queue
    @card = Card.find(head_of_queue)
  end

  private
    def forward!
      self.queue_index += 1
      self.queue_index = 0 if queue[queue_index].nil?
      save
    end

    def head_of_queue
      build_queue!
      queue[queue_index]
    end

    def build_queue!
      self.queue = [] if self.queue.any?
      queue_index = 0
      cards.limit(cards_per_day).each { |card| add_to_queue(card) }
      queue.shuffle! unless Rails.env.test?
      save
    end

    def add_to_queue(card)
      times = send("repeat_#{card.level}")
      self.queue += Array.new(times, card.id)
    end

    def substitute_card
      cards.limit(1).where.not(id: queue.uniq)
    end

    def cards
      deck.cards.where(learned: false)
                .select(:id, :level)
                .order(review_count: :asc, miss_count: :desc)
    end
end
