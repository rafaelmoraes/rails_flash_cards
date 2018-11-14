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
end
