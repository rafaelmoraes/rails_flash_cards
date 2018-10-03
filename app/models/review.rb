# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  default_scope -> { includes %i[deck user] }

  RIGHT_ANSWER = "r".freeze
  WRONG_ANSWER = "w".freeze

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

  validates_numericality_of :queue_position,
                            only_integer: true,
                            greater_than_or_equal_to: 1

  validates :daily_review_done, inclusion: { in: [true, false] }

  validate do
    errors.add(:queue, "needs be an Array") if queue.nil? || !queue.is_a?(Array)
  end

  def learned_and_forward!
    Review.transaction do
      current_card.learned!
      forward!
    end
  end

  def save_answer(answer)
    Review.transaction do
      answer == RIGHT_ANSWER ? current_card.hit! : current_card.miss!
      forward!
    end
  end

  def current_card_id
    create_session_if_necessary!
    card_id = self.queue.first
    card_available?(card_id) ? card_id : replace_current_card_if_available!
  end

  def current_card
    return @card if @card && @card.id == current_card_id
    @card = Card.find(current_card_id)
  end

  def session_completed?
    daily_review_done? && self.queue.empty?
  end

  def change_difficulty!(difficulty_level)
    old_times_to_repeat = times_to_repeat(current_card.difficulty_level)
    Review.transaction do
      return unless current_card.change_difficulty!(difficulty_level)

      times_on_queue = self.queue.count current_card.id
      current_times_to_repeat = times_to_repeat(difficulty_level)

      if current_times_to_repeat > old_times_to_repeat
        increase_card_on_queue(current_times_to_repeat, times_on_queue)
      else
        decrease_card_on_queue(current_times_to_repeat, times_on_queue)
      end
      save
    end
  end

  def total_queue_size
    queue.size + queue_position - 1
  end

  private
    def card_available?(card_id)
      deck.cards.find_by(id: card_id, learned: false)
    end

    def increase_card_on_queue(times_to_repeat, times_on_queue)
      times_to_add = times_to_repeat - times_on_queue
      head = self.queue.slice(0, 1)
      tail = self.queue.slice(1, self.queue.size)
      tail += Array.new(times_to_add, current_card.id)
      tail.shuffle!
      self.queue = head + tail
    end

    def decrease_card_on_queue(times_to_repeat, times_on_queue)
      if times_on_queue > times_to_repeat
        delete_times = times_on_queue - times_to_repeat
        head = self.queue.slice(0, 1)
        tail = self.queue.slice(1, self.queue.size)
        tail.each_with_index do |element, index|
          if element == current_card.id
            tail[index] = nil
            delete_times -= 1
            break if delete_times == 0
          end
        end
        self.queue = head + tail.compact
      end
    end

    def times_to_repeat(difficulty_level)
      send "repeat_#{difficulty_level}"
    end

    def forward!
      self.queue.delete_at 0
      self.queue_position += 1
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
        self.queue_position = 1
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
      self.queue += Array.new(times_to_repeat(card.level), card.id)
    end

    def replace_current_card_if_available!
      self.queue.delete(queue.first)
      substitute = find_substitute
      if substitute
        add_to_queue substitute
        shuffle_queue
      end
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
