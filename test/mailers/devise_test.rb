# frozen_string_literal: true

require "test_helper"

class DeviseMailerTest < ActionMailer::TestCase
  HOST = "localhost:3000"
  TOKEN = 123456
  setup do
    @user = users(:always_valid)
  end

  test "reset password instructions" do
    locale_each do
      email = Devise::Mailer.reset_password_instructions @user, TOKEN
      assert_emails 1 do
        email.deliver_now
      end
      assert_equal [@user.email], email.to
      assert_equal t(:subject), email.subject
      string_body = email.body.to_s
      assert_match t(:link_label), string_body
      assert_match change_password_link, string_body
      assert_match t(:paragraph_1, email_or_name: @user.name), string_body
      [2, 3, 4].each { |number| assert_match t(:paragraph_2), string_body }
    end
  end

  private
    def locale_each
      I18n.available_locales.each do |locale|
        I18n.locale = locale
        puts "Using: #{I18n.locale}"
        Devise::Mailer.default_url_options[:host] = HOST
        yield(locale)
      end
    end

    def t(key, *args)
      I18n.t("devise.mailer.reset_password_instructions.#{key}", *args)
    end

    def change_password_link(locale: I18n.locale, token: TOKEN, host: HOST)
      "#{host}/#{locale}/users/password/edit?reset_password_token=#{token}"
    end
end
