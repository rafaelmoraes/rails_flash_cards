# frozen_string_literal: true

# This model represents the flash cards
class Card < ApplicationRecord
  DIFFICULTY_LEVELS = { easy: 'easy', medium: 'medium', hard: 'hard' }.freeze

  belongs_to :deck, counter_cache: true
  has_one :user, through: :deck

  validates :front, :back, presence: true, length: { maximum: 150 }
  validates :difficulty_level, inclusion: DIFFICULTY_LEVELS.values
  validates :learned, inclusion: [true, false]
  validates_numericality_of :views_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0

  alias_attribute :level, :difficulty_level

  enum difficulty_level: DIFFICULTY_LEVELS
end
