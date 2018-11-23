# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :firefox, screen_size: [1280, 720]

  protected
    def t(key, *params)
      return I18n.t(key, *params) if key.is_a? Symbol
      I18n.t("#{i18n_plural_scope}.#{key}", *params)
    end

    def t_fill_in(attr_name, *params)
      fill_in I18n.t("activerecord.attributes.#{i18n_singular_scope}.#{attr_name}"),
              *params
    end

    def t_click_submit(key, *params)
      click_on I18n.t("helpers.submit.#{key}",
                      model: I18n.t("activerecord.models.#{i18n_singular_scope}")),
               *params
    end

    def t_assert_text(key, *params)
      assert_text t(key), *params
    end

    def i18n_plural_scope
      @_i18n_plural_scope ||= self.class.to_s.split("Test").first
                                                           .gsub("::", ".")
                                                           .underscore
    end

    def i18n_singular_scope
      @_i18n_singular_scope ||= i18n_plural_scope.gsub("admin.", "").singularize
    end
end
