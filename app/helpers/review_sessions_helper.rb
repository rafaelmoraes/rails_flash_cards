# frozen_string_literal: true

module ReviewSessionsHelper
  def button_to_change_difficulty(label, value, opts = {})
    current_difficulty = @review.current_card.difficulty_level == value ? true : false
    button_tag t(".level.#{label}"),
               value: value,
               name: :change_to,
               disabled: current_difficulty,
               class: opts[:class]
  end

  def form_tag_patch(action, opts = {})
    form_tag(
      [@review, @review.current_card, action],
      method: :patch,
      class: opts[:class]
    ) do
      yield
    end
  end
end
