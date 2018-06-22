class Card < ApplicationRecord
  belongs_to :deck
  alias_attribute :level, :difficulty_level

  enum difficulty_level: {
    easy: 'easy',
    medium: 'medium',
    hard: 'hard'
  }
end
