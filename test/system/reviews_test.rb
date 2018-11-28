require "application_system_test_case"

class ReviewsTest < ApplicationSystemTestCase
  NUMERIC_ATTRS = %i[cards_per_day repeat_easy repeat_medium repeat_hard].freeze

  setup do
    @review = reviews(:always_valid)
  end

  test "should change the review settings parameters to 9999" do
    visit edit_review_path(@review)
    v = "9999"
    NUMERIC_ATTRS.each do |field_name|
      t_fill_in field_name, with: v
      click_on t("form.save")
      assert_equal v, find("#review_#{field_name}").value
    end
  end

  test "should show error messages" do
    visit edit_review_path(@review)
    t_fill_in NUMERIC_ATTRS.sample, with: nil
    click_on t("form.save")
    assert_selector "#error_explanation"
  end
end
