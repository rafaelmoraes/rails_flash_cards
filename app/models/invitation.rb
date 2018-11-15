# frozen_string_literal: true
# TODO: implemente pick language
class Invitation < ApplicationRecord
  belongs_to :user

  before_validation :generate_token

  validates :token, presence: true

  validates :guest_name,
            length: 2..90,
            format: { with: /\A[[:alpha:]]{2,}( [[:alpha:]]{2,})*\z/ }
  validates_uniqueness_of :token, :guest_name

  # URI::MailTo::EMAIL_REGEXP
  validates :guest_email,
    format: { with: Devise.email_regexp, message: :invalid },
    allow_blank: true,
    allow_nil: true
  validates_uniqueness_of :guest_email, allow_blank: true, allow_nil: true

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(22, false)
  end

  def self.token_valid?(token)
    exists?(token: token)
  end
end
