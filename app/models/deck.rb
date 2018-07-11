# frozen_string_literal: true

# This class represents the user deck
class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  has_and_belongs_to_many :reviews, dependent: :destroy

  validates :name, presence: true, length: { maximum: 75 }
  validates :detail, length: { maximum: 255 }
  validates_numericality_of :cards_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0
  validate :name_is_unique_between_the_user_decks

  after_create :create_default_review

  def name_is_unique_between_the_user_decks
    deck = Deck.where_name_and_user(name, user_id)
    errors.add(:name, 'already exist') if deck && deck.id != id
  end

  def self.where_name_and_user(name, user_or_user_id)
    user_id = user_or_user_id.is_a?(User) ? user_or_user_id.id : user_or_user_id
    Deck.where(user_id: user_id).where('lower(name) = lower(?)', name).first
  end

  def create_default_review
    reviews.create user: user
  end
end
