# frozen_string_literal: true

require "test_helper"

# This class implements the unit tests to User model
class UserTest < ActiveSupport::TestCase
  test "should not save without any parameter" do
    user = User.new
    assert_not user.save
  end

  test "should be invalid" do
    user = User.new
    assert_not user.valid?
  end

  test "should be valid" do
    valid_user = users(:always_valid)
    assert valid_user.valid?
  end

  test "should save" do
    valid_user = users(:always_valid)
    assert valid_user.save
  end

  test "should has an error when name is nil" do
    rafael = users(:rafael)
    rafael.name = nil
    rafael.valid?
    assert_includes rafael.errors, :name
  end

  test "should has an error when name is blank" do
    rafael = users(:rafael)
    rafael.name = ""
    rafael.valid?
    assert_includes rafael.errors, :name
  end

  test "should has an error about name minimum length" do
    rafael = users(:rafael)
    rafael.name = "R"
    rafael.valid?
    assert_includes rafael.errors, :name
  end

  test "should has an error about name maximum length" do
    more_than_90_letters = "Rafael" * 16
    rafael = users(:rafael)
    rafael.name = more_than_90_letters
    rafael.valid?
    assert_includes rafael.errors, :name
  end

  test "should remove blank spaces at begin and at end" do
    rafael = users :rafael
    rafael.name = " Rafael "
    rafael.valid?
    assert_equal "Rafael", rafael.name
  end

  test "should be a valid name" do
    user = users(:always_valid)
    assert user.valid?
    user.name = "Valde Ramas o Retorno"
    assert user.valid?
  end

  test "should be associated with model Deck" do
    valid_user = users(:always_valid)
    assert_respond_to valid_user, :decks
  end

  test "should be associated with model Card" do
    valid_user = users :always_valid
    assert_respond_to valid_user, :cards
  end

  test "should be associated with model Setting" do
    valid_user = users :always_valid
    assert_respond_to valid_user, :setting
  end

  test "should create a setting after create a new user" do
    new_user = User.create name: "João da Silva",
                           email: "xpto@email.com",
                           password: "123456",
                           password_confirmation: "123456",
                           invitation_token: "4nUMH4zxVfkTwK3MavvmEYHwGRH_QZ"
    assert_not_nil new_user.setting
  end

  test "should destroy de invitation after create" do
    invitation = Invitation.create user: users(:always_valid),
                                   guest_name: "Test callback destroy invitation"
    assert_not invitation.new_record?
    user = User.create name: invitation.guest_name,
                       email: "test_invitation@destroy.com",
                       password: "123456",
                       password_confirmation: "123456",
                       invitation_token: invitation.token
    assert_not user.new_record?
    user.send :destroy_invitation
    assert_nil Invitation.find_by(token: user.invitation_token)
  end
end
