# frozen_string_literal: true

# Module with helpers to Cards view
module CardsHelper
  RadioButton = Struct.new(:value, :label)

  def difficulty_levels_to_radio
    Card::DIFFICULTY_LEVELS.map { |k, v| RadioButton.new(k, v).freeze }
  end
end
