# frozen_string_literal: true

require 'test_helper'

# Unit tests to Setting model
class SettingTest < ActiveSupport::TestCase
  test 'should save' do
    setting = Setting.new locale: 'pt-BR',
                          cards_per_review: 20,
                          repeat_easy_card: 1,
                          repeat_medium_card: 2,
                          repeat_hard_card: 3,
                          user: User.new(
                            email: 'xpto@email.com',
                            password: '123456',
                            password_confirmation: '123456'
                          )
    assert setting.save
  end

  test 'should not save if user already has a setting' do
    s = clone_setting(:one, user: users(:always_valid))
    refute s.save
  end

  test 'should has an error about locale not available' do
    stg = clone_setting :one, locale: :jp
    refute stg.valid?
    refute_empty stg.errors[:locale]
  end

  test 'should has errors about attributes not be positive integer' do
    stg = clone_setting(:one)
    %i[repeat_easy_card repeat_medium_card
       repeat_hard_card cards_per_review].each do |method_name|
      [-1, 1.15, nil].each do |number|
        stg.send("#{method_name}=", number)
        refute stg.valid?
        refute_empty stg.errors[method_name]
      end
    end
  end

  private

  def clone_setting(fixture = :always_valid, opts = {})
    s = settings(fixture).clone
    opts.each { |k, v| s.send("#{k}=", v) }
    s
  end
end
