# frozen_string_literal: true

require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:non_admin)
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should destroy admin_user" do
    assert_difference("User.count", -1) do
      delete admin_user_url(@user)
    end

    assert_redirected_to admin_users_url
  end

  test "should throws not found exception if user is not admin" do
    assert @current_user.admin?
    sign_out @current_user

    assert_not users(:rafael).admin?
    sign_in users(:rafael)

    assert_raises ActionController::RoutingError do
      get admin_users_url
    end
  end
end
