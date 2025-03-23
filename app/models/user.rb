class User < ApplicationRecord
  has_secure_password

  has_many :setting, dependent: :destroy

  include UserHelper

  validates :username,
            presence: true,
            uniqueness: true,
            length: { maximum: 32 },
            format: { with: /\A[a-zA-Z0-9\_]+\z/ }

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :access_level,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  validates :user_rating,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  before_save { self.email = email.downcase }

  after_initialize :set_default_user_rating, if: :new_record?

  def set_default_user_rating
    self.user_rating ||= 0
  end
end
