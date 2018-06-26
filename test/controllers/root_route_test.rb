# frozen_string_literal: true

require 'test_helper'

# Tests if root path the sign in page
class RootRouteTest < ActionDispatch::IntegrationTest
  test 'should open the sign_in page' do
    assert_routing '/', controller: 'devise/sessions', action: 'new'
  end
end
