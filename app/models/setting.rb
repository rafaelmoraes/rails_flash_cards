# frozen_string_literal: true

# User settings
class Setting < ApplicationRecord
  COLOR_SCHEMES = %w[light dark].freeze

  belongs_to :user

  validates_uniqueness_of :user
  validates :locale,
            presence: true,
            inclusion: I18n.available_locales.map(&:to_s)

  validates :color_scheme,
            presence: true,
            inclusion: COLOR_SCHEMES

  validates_numericality_of :cards_per_review,
                            :repeat_easy_card,
                            :repeat_medium_card,
                            :repeat_hard_card,
                            greater_than: 0,
                            only_integer: true

  def self.default_color_scheme
    COLOR_SCHEMES.first
  end
end
