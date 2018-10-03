# frozen_string_literal: true

module ReviewSessionsHelper
  def button_to_change_difficulty(label, value)
    current_difficulty = @review.current_card.level == value ? true : false
    button_tag t(".level.#{label}"),
               value: value,
               name: :change_to,
               disabled: current_difficulty
  end

  def form_tag_patch(action)
    form_tag([@review, @review.current_card, action], method: :patch) do
      yield
    end
  end
end
