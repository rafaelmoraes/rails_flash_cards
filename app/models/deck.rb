# frozen_string_literal: true

# This class represents the user deck
class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy

  validates :name, presence: true, length: { maximum: 75 }
  validates :detail, length: { maximum: 255 }

  validates_numericality_of :cards_count,
                            only_integer: true,
                            greater_than_or_equal_to: 0
  validates_numericality_of :cards_per_review,
                            :repeat_easy_card,
                            :repeat_medium_card,
                            :repeat_hard_card,
                            only_integer: true,
                            greater_than: 0

  validates_numericality_of :card_id_on_review,
                            only_integer: true,
                            greater_than: 0,
                            allow_nil: true

  validates_with do |deck|
    return true if deck.card_ids_on_review.is_a? Array
    errors.add(:card_ids_on_review, "should be a Array")
  end

  validate :user_not_have_another_deck_with_same_name?

  after_initialize :set_defaults

  def set_defaults
    return unless user
    %i[cards_per_review repeat_easy_card
       repeat_medium_card repeat_hard_card].each do |attr_name|
      self[attr_name] = user.setting.send attr_name
    end
  end

  def user_not_have_another_deck_with_same_name?
    deck = Deck.where_name_and_user_eql(name, user_id)
    errors.add(:name, "already exist") if deck && deck.id != id
  end

  def self.where_name_and_user_eql(name, user_or_user_id)
    user_id = user_or_user_id.is_a?(User) ? user_or_user_id.id : user_or_user_id
    Deck.where(user_id: user_id).where("lower(name) = lower(?)", name).first
  end
end
