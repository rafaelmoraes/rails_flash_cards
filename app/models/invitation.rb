# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :user

  before_validation :generate_token

  validates :token, :guest_name, presence: true
  validates_uniqueness_of :token, :guest_name

  # URI::MailTo::EMAIL_REGEXP
  validates :guest_email,
    format: { with: Devise.email_regexp, message: :invalid_email },
    allow_nil: true
  validates_uniqueness_of :guest_email, allow_nil: true

  def generate_token
    self.token = SecureRandom.urlsafe_base64(22, false) if self.token.nil?
  end

  def self.token_valid?(token)
    exists?(token: token)
  end
end
