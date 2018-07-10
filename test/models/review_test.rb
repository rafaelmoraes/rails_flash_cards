# frozen_string_literal: true

require 'test_helper'

# Unit test to model Review
class ReviewTest < ActiveSupport::TestCase
  REVIEW_ATTRS = %i[cards_per_review repeat_easy_card
                    repeat_medium_card repeat_hard_card].freeze

  test 'should has many decks' do
    assert Review.new.respond_to? :decks
  end

  test 'all these attributes should to be a positive integer' do
    r = reviews :always_valid
    REVIEW_ATTRS.each do |method|
      [-1, 0, 1.1].each do |number|
        r.send("#{method}=", number)
        refute r.valid?
      end
      [10, 20, 31].each do |number|
        r.send("#{method}=", number)
        assert r.valid?
      end
    end
  end
end
