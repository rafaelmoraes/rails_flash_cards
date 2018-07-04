# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'awesome_print'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Set defaults integration tests
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    self.default_url_options = { locale: I18n.locale }
    sign_in users(:always_valid)
  end
end
