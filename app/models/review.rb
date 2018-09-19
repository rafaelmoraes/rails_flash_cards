# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  belongs_to :current_card, class_name: "Card", foreign_key: :current_card_id

  validates_numericality_of :cards_per_day,
                            :repeat_easy,
                            :repeat_medium,
                            :repeat_hard,
                            only_integer: true,
                            greater_than: 0

  def hit_and_update_current_card!
    Review.transaction do
      current_card.hit_and_save
      next_card!
    end
  end

  def miss_and_update_current_card!
    Review.transaction do
      current_card.miss_and_save
      next_card!
    end
  end

  private
    def next_card!
      forward_queue
      save
    end

    def forward_queue
      refresh_queue
      forward_queue_index
      next_card_id = queue[queue_index]
      unless Card.exists?(next_card_id)
        queue.delete(next_card_id)
        forward_queue
      end
      self[:current_card_id] = next_card_id
    end

    def forward_queue_index
      next_index = queue_index + 1
      next_index = 0 if queue[next_index].nil?
      self[:queue_index] = next_index
    end

    def refresh_queue
      build_queue if queue.empty?
    end

    def build_queue
      create_queue
      queue.shuffle!
      self[:queue_index] = 0
      self[:current_card_id] = queue.first
      self
    end

    def add_to_queue(card)
      send("repeat_#{card.level}").times { queue << card.id }
    end

    def create_queue
      self.queue = []
      select_cards.each { |card| add_to_queue card }
    end

    def select_cards
      deck.cards.order(miss_count: :desc)
                .order(hit_count: :asc)
                .limit(cards_per_day)
                .select(:id, :level)
    end
end
