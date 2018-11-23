# frozen_string_literal: true

# The User model represents every user that wish has one or more flash card deck
class User < ApplicationRecord
  has_many :decks, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_one :setting, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name,
            length: 2..90,
            format: { with: /\A[[:alpha:]]{2,}( [[:alpha:]]{2,})*\z/ }

  before_validation :strip_name

  after_create :create_setting, :destroy_invitation
# TODO: validate unique email
  private

    def strip_name
      self[:name] = self[:name].strip if self[:name]
    end

    def create_setting
      return if reload && setting
      setting = Setting.new user: self
      setting.save!
    end

    def destroy_invitation
      Invitation.find_by(token: self.invitation_token)
        &.destroy! if self.invitation_token&.present?
    end
end
