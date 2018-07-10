# frozen_string_literal: true

# Model to handle review sessions
class Review < ApplicationRecord
  has_and_belongs_to_many :decks
  has_and_belongs_to_many :cards
  belongs_to :user

  validates_numericality_of :cards_per_review,
                            :repeat_easy_card,
                            :repeat_medium_card,
                            :repeat_hard_card,
                            only_integer: true,
                            greater_than: 0
end
