# frozen_string_literal: true

require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_out @current_user
  end

  test "should access sign up if there is a valid token" do
    @invitation = Invitation.create user: users(:always_valid),
                                    guest_name: "José da Silva",
                                    guest_email: "josedasilva@email.com"
    get new_user_registration_url(@invitation.to_params_link)
    assert_response :success
  end

  test "should raise ActionController::RoutingError if there isn't a token" do
    assert_raise ActionController::RoutingError do
      get new_user_registration_url
    end
  end

  test "should raise ActionController::RoutingError if is invalid token" do
    assert_raise ActionController::RoutingError do
      get new_user_registration_url(invitation_token: 123456)
    end
  end

  test "should create user setting and destroy the invitations after create user" do
    name = "Convidado Setting"
    email = "convidado_sessiong@email.com"
    invite = Invitation.create user: users(:always_valid),
                               guest_name: name,
                               guest_email: email
    assert_difference("User.count") do
      post user_registration_url(invitation_token: invite.token), params: {
        user: { name: name,
                email: email,
                password: 123456,
                password_confirmation: 123456,
                invitation_token: invite.token } }
    end
    user = User.find_by(invitation_token: invite.token)
    assert_not Invitation.exists?(invite.id)
    assert_not_nil user.setting
    assert_equal I18n.locale, user.setting.locale.to_sym
    assert_redirected_to root_url
  end
end
