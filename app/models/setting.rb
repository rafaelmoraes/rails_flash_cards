# frozen_string_literal: true

# User settings
class Setting < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :user
  validates :locale,
            presence: true,
            inclusion: I18n.available_locales.map(&:to_s)
  validates_numericality_of :cards_per_session,
                            :repeat_easy_card,
                            :repeat_medium_card,
                            :repeat_hard_card,
                            greater_than: 0,
                            only_integer: true
end
