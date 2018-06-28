# frozen_string_literal: true

# Module with helpers to Cards view
module CardsHelper
  def difficulty_levels_to_radio
    radio_button = Struct.new(:value, :label)
    Card::DIFFICULTY_LEVELS.map do |level|
      radio_button.new(level, level).freeze
    end
  end
end
