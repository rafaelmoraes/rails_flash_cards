# frozen_string_literal: true

# Module with helpers for Cards view
module CardsHelper
  RadioButton = Struct.new(:value, :label)

  def difficulty_levels_for_radio_button
    Card::DIFFICULTY_LEVELS.map do |k, v|
      RadioButton.new(k, t_difficulty_level(v)).freeze
    end
  end

  def t_difficulty_level(key)
    t(".difficulty_levels.#{key}")
  end
end
