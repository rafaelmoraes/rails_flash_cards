# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :deck

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

  # validates_with do |review|
  #   return true if review.card_ids_on_review.is_a? Array
  #   errors.add(:card_ids_on_review, "should be a Array")
  # end
end
