# frozen_string_literal: true

require "test_helper"

class InvitationTest < ActiveSupport::TestCase
  setup do
    @invitation = invitations(:always_valid)
  end

  test "should has a user to be save" do
    assert @invitation.valid?
    @invitation.user = nil
    assert_not @invitation.save
  end

  test "should has a valid guest_name to be save" do
    assert @invitation.valid?
    @invitation.guest_name = nil
    assert_not @invitation.save
    @invitation.guest_name = ""
    assert_not @invitation.save
  end

  test "should has a valid email or nothing" do
    assert @invitation.valid?
    @invitation.guest_email = nil
    assert @invitation.save
    @invitation.guest_email = "invalid_email"
    assert_not @invitation.save
  end

  test "should generate the token before validation" do
    assert_not_nil @invitation.token
    assert @invitation.valid?
    @invitation.token = nil
    assert @invitation.valid?
  end

  test "should has an error about guest_email taken" do
    i = Invitation.new
    i.guest_email = users(:always_valid).email
    assert_not i.valid?
    assert_not_empty i.errors[:guest_email]
  end

  test "should not save if locale is not available" do
    i = Invitation.new
    i.locale = :uk
    assert_not i.valid?
    assert_not_empty i.errors[:locale]
  end

  test "should return a hash to be use on the invitation link" do
    i = invitations(:always_valid)
    expected = { guest_name: i.guest_name,
                 guest_email: i.guest_email,
                 locale: i.locale,
                 invitation_token: i.token }
    assert_equal expected, i.to_params_link

    i.guest_email = nil
    expected.delete :guest_email
    assert_equal expected, i.to_params_link
  end
end
