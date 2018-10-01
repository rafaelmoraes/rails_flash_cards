# frozen_string_literal: true

module ReviewSessionsHelper
  def link_to_change_difficulty(label, value)
    css_class = @review.current_card.level == value ? "active" : "inactive"
    link_to t(".#{label}"),
      review_card_change_difficulty_path(@review,
                                         @review.current_card,
                                         to: value),
      class: css_class
  end
end
