# frozen_string_literal: true

require 'test_helper'

# This class implements the unit tests to User model
class UserTest < ActiveSupport::TestCase
  test 'should not save without any parameter' do
    user = User.new
    assert_not user.save
  end

  test 'should be invalid' do
    user = User.new
    assert_not user.valid?
  end

  test 'should be valid' do
    valid_user = users(:always_valid)
    assert valid_user.valid?
  end

  test 'should save' do
    valid_user = users(:always_valid)
    assert valid_user.save
  end

  test 'should has an error when first_name is nil' do
    rafael = users(:rafael)
    rafael.first_name = nil
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should has an error when first_name is blank' do
    rafael = users(:rafael)
    rafael.first_name = ''
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should has an error about first_name minimum length' do
    rafael = users(:rafael)
    rafael.first_name = 'R'
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should has an error about first_name maximum length' do
    more_than_40_letters = 'Rafael' * 7
    rafael = users(:rafael)
    rafael.first_name = more_than_40_letters
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should has an error when first_name has blank space in the begin' do
    rafael = users :rafael
    rafael.first_name = ' Rafael'
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should has an error when first_name has blank space in the middle' do
    rafael = users(:rafael)
    rafael.first_name = 'Rafael Moraes'
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should has an error when first_name has blank space in the end' do
    rafael = users :rafael
    rafael.first_name = 'Rafael '
    rafael.valid?
    assert_includes rafael.errors, :first_name
  end

  test 'should capitalize first_name before save' do
    rafael = users :rafael
    rafael.first_name = 'rAfaeL'
    rafael.save
    assert_equal 'Rafael', rafael.first_name
  end

  test 'should has an error when last_name is nil' do
    rafael = users(:rafael)
    rafael.last_name = nil
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should has an error when last_name is blank' do
    rafael = users(:rafael)
    rafael.last_name = ''
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should has an error about last_name minimum length' do
    rafael = users(:rafael)
    rafael.last_name = 'M'
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should has an error about last_name maximum length' do
    more_than_40_letters = 'Moraes' * 7
    rafael = users(:rafael)
    rafael.last_name = more_than_40_letters
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should has an error when last_name has blank space in the begin' do
    rafael = users :rafael
    rafael.last_name = ' Rafael'
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should has an error when last_name has blank space in the middle' do
    rafael = users(:rafael)
    rafael.last_name = 'Rafael Moraes'
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should has an error when last_name has blank space in the end' do
    rafael = users :rafael
    rafael.last_name = 'Rafael '
    rafael.valid?
    assert_includes rafael.errors, :last_name
  end

  test 'should capitalize last_name before save' do
    rafael = users :rafael
    rafael.last_name = 'MoRaes'
    rafael.save
    assert_equal 'Moraes', rafael.last_name
  end

  test 'should return full_name' do
    valid_user = users(:always_valid)
    assert_equal 'João Silva', valid_user.full_name
  end

  test 'should be associated with model Deck' do
    valid_user = users(:always_valid)
    assert_respond_to valid_user, :decks
  end

  test 'should be associated with model Card' do
    valid_user = users :always_valid
    assert_respond_to valid_user, :cards
  end
end
