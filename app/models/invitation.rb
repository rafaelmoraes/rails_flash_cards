# frozen_string_literal: true

# TODO: implemente pick language
class Invitation < ApplicationRecord
  belongs_to :user

  before_validation :generate_token

  validates :token, presence: true

  validates :guest_name,
            length: 2..90,
            format: { with: User::PERSON_NAME_REGEX }
  validates_uniqueness_of :token, :guest_name

  # URI::MailTo::EMAIL_REGEXP
  validates :guest_email,
    format: { with: Devise.email_regexp, message: :invalid },
    allow_blank: true,
    allow_nil: true
  validates_uniqueness_of :guest_email, allow_blank: true, allow_nil: true

  validate do |i|
    errors.add(:guest_email, :taken) if User.exists?(email: i.guest_email)
  end

  validates :locale,
            presence: true,
            inclusion: I18n.available_locales.map(&:to_s)

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(22, false)
  end

  def to_params_link
    params = { guest_name: self.guest_name,
               invitation_token: self.token,
               locale: self.locale }
    params[:guest_email] = self.guest_email if self.guest_email.present?
    params
  end

  def self.token_valid?(token)
    exists?(token: token)
  end
end
