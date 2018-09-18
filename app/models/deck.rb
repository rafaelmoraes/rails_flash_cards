# frozen_string_literal: true

# This class represents the user deck
class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  has_one :review, dependent: :destroy

  validates :name, presence: true, length: { maximum: 75 }
  validates :detail, length: { maximum: 255 }

  validates_numericality_of :cards_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0

  validate :user_not_have_another_deck_with_same_name?

  def user_not_have_another_deck_with_same_name?
    deck = Deck.where_name_and_user_eql(name, user_id)
    errors.add(:name, "already exist") if deck && deck.id != id
  end

  def self.where_name_and_user_eql(name, user_or_user_id)
    user_id = user_or_user_id.is_a?(User) ? user_or_user_id.id : user_or_user_id
    Deck.where(user_id: user_id).where("lower(name) = lower(?)", name).first
  end
end
