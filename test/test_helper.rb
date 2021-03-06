# frozen_string_literal: true

require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "awesome_print"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Set defaults integration tests
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # parallelize(workers: :number_of_processors)

  setup do
    @current_user = users(:always_valid)
    sign_in @current_user
    I18n.locale = users(:always_valid).setting.locale
    self.default_url_options = { locale: I18n.locale }
    puts "Using locale: #{I18n.locale}"
  end
end
