# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  # has_many :cards, through: :deck

  before_create :build_session

  # validates_numericality_of :session_size,
  #                           :repeat_easy_cards,
  #                           :repeat_medium_cards,
  #                           :repeat_hard_cards,
  #                           only_integer: true,
  #                           greater_than: 0

  # validates_numericality_of :current_card_id,
  #                           only_integer: true,
  #                           greater_than: 0,
  #                           allow_nil: true

  def next_card_id
    build_session if card_ids.size < cards_per_day
    current_id = card_ids[card_ids.index(current_card_id) + 1]
    current_id = card_ids.first if current_id.nil?
    self[:current_card_id] = current_id
    current_id if save
  end

  private
    def build_session
      self[:card_ids] = deck.cards.limit(cards_per_day).pluck(:id)
      self[:current_card_id] = card_ids.first if current_card_id.nil?
    end
end
