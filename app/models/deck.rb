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
end
