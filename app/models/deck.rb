# frozen_string_literal: true

# This class represents the user deck
class Deck < ApplicationRecord
  HEX_COLORS = %w[#ffffff #008744 #0057e7 #d62d20 #ffa700].freeze

  belongs_to :user
  has_many :cards, dependent: :destroy
  has_one :review, dependent: :destroy

  validates :name, presence: true, length: { maximum: 75 }
  validates :detail, length: { maximum: 255 }
  validates :color,
            length: { minimum: 4, maximum: 7 },
            inclusion: { in: Deck::HEX_COLORS }

  validates_numericality_of :cards_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0

  validates :daily_review_done, inclusion: { in: [true, false] }

  validate :user_not_have_another_deck_with_same_name?

  def user_not_have_another_deck_with_same_name?
    deck = Deck.where_name_and_user_eql(name, user_id)
    errors.add(:name, "already exist") if deck && deck.id != id
  end

  def self.where_name_and_user_eql(name, user_or_user_id)
    user_id = user_or_user_id.is_a?(User) ? user_or_user_id.id : user_or_user_id
    Deck.where(user_id: user_id).where("lower(name) = lower(?)", name).first
  end

  def cards_for_review(limit, select_attrs = [:id, :level])
    cards.where(learned: false)
         .order(review_count: :asc, miss_count: :desc)
         .select(select_attrs)
         .limit(limit)
  end

  def find_substitute_card(current_queue_ids)
    cards_for_review(1).where.not(id: current_queue_ids).first
  end

  def has_cards_to_review?
    cards_count > 0 && cards.where(learned: false).select(:learned).count > 0
  end

  def offensive
    review.nil? ? 0 : review.offensive
  end

  def reviews_completed
    review.nil? ? 0 : review.reviews_completed
  end

  def learned_cards_count
    cards.where(learned: true).count
  end
end
