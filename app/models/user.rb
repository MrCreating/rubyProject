class User < ApplicationRecord
  has_secure_password

  validates :username,
            presence: true,
            uniqueness: true,
            length: { maximum: 32 },
            format: { with: /\A[a-zA-Z0-9\-]+\z/, message: "can only contain letters, numbers, and dashes" }

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "format is incorrect" }

  before_save { self.email = email.downcase }
end
