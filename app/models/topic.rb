class Topic < ApplicationRecord
  validates :title, presence: true, length: { maximum: 96 }
  validates :description, length: { maximum: 4096 }, allow_blank: true
  validates :user_id, presence: true

  has_many :topics_attachments
  has_many :attachments, through: :topics_attachments

  has_many :votes, dependent: :destroy

  belongs_to :user
end