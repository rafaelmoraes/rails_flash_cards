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
end
