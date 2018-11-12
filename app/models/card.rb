# frozen_string_literal: true

# This model represents the flash cards
class Card < ApplicationRecord
  DIFFICULTY_LEVELS = { easy: "easy", medium: "medium", hard: "hard" }.freeze

  belongs_to :deck, counter_cache: true
  belongs_to :user

  validates :front, :back, presence: true, length: { maximum: 150 }
  validates :difficulty_level, inclusion: DIFFICULTY_LEVELS.values
  validates :learned, inclusion: [true, false]
  validates_numericality_of :review_count,
                            :hit_count,
                            :miss_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0

  validate :deck_belongs_to_same_user?

  alias_attribute :level, :difficulty_level

  enum difficulty_level: DIFFICULTY_LEVELS

  def deck_belongs_to_same_user?
    return true if deck.nil? || user == deck.user
    errors.add(:deck, "must be your")
    false
  end

  def hit!
    self.review_count += 1
    self.hit_count += 1
    save
  end

  def miss!
    self.review_count += 1
    self.miss_count += 1
    save
  end

  def change_difficulty!(difficulty)
    self.difficulty_level = difficulty
    save
  end

  def learned!
    return true if learned?
    self.learned = true
    save
  end

  def self.where_front(text)
    where ["front like ?", "%#{text}%"]
  end

  def self.where_back(text)
    where ["back like ?", "%#{text}%"]
  end

  def self.where_front_or_back(text)
    where_front(text).or(where_back(text))
  end
end
