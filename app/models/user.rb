class User < ApplicationRecord

  has_many :decks, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name,
            :last_name,
            length: 2..40,
            format: { with: /\A[[:alpha:]]{2,}\z/ }

  before_save :capitalize_names

  def full_name
    "#{first_name} #{last_name}"
  end

  private
    def capitalize_names
      self[:first_name] = self[:first_name].capitalize
      self[:last_name] = self[:last_name].capitalize
    end
end
