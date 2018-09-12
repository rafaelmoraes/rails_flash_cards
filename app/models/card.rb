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
                            :fail_count,
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

  def review_count
    hit_count + fail_count
  end

  def hit_and_save
    self[:hit_count] += 1
    save
  end

  def fail_and_save
    fail_count += 1
    save
  end

  def next_card_id_for_review
    card_ids = deck.pick_card_ids_for_review
    index = card_ids.index(id) + 1
    next_card_id = card_ids[index] || card_ids.first
    deck.card_id_on_review = next_card_id
    next_card_id if deck.save
  end
end
