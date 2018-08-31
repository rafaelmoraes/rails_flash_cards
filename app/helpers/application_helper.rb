# frozen_string_literal: true

# View helpers for all views
module ApplicationHelper
  def bool_to_yes_or_no(boolean)
    boolean ? t("yes") : t("no")
  end
end
