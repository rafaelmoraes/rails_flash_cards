# frozen_string_literal: true

# This model represents the flash cards
class Card < ApplicationRecord
  belongs_to :deck, counter_cache: true

  validates :front, :back, presence: true, length: { maximum: 150 }
  validates :difficulty_level, inclusion: %w[easy medium hard]
  validates :learned, inclusion: [true, false]
  validates_numericality_of :views_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0

  alias_attribute :level, :difficulty_level

  enum difficulty_level: { easy: 'easy', medium: 'medium', hard: 'hard' }
end
