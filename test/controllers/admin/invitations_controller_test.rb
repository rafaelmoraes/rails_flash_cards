# frozen_string_literal: true

require "test_helper"

class Admin::InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invitation = invitations(:always_valid)
  end

  test "should get index" do
    get admin_invitations_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_invitation_url
    assert_response :success
  end

  test "should create invitation" do
    assert_difference("Invitation.count") do
      post admin_invitations_url, params: { invitation: {
        guest_name: "Test Guest"
        } }
    end

    assert_redirected_to admin_invitation_url(Invitation.last)
  end

  test "should show invitation" do
    get admin_invitation_url(@invitation)
    assert_response :success
  end

  test "should destroy invitation" do
    assert_difference("Invitation.count", -1) do
      delete admin_invitation_url(@invitation)
    end

    assert_redirected_to admin_invitations_url
  end

  test "should throws not found exception if user is not admin" do
    assert @current_user.admin?
    sign_out @current_user

    assert_not users(:rafael).admin?
    sign_in users(:rafael)

    assert_raises ActionController::RoutingError do
      get admin_invitations_url
    end
  end
end
